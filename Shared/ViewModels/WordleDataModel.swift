//
//  WordleDataModel.swift
//  WordleClone
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

// swiftlint:disable force_unwrapping
class WordleDataModel: ObservableObject {
    // MARK: - State
    /**
     @Published is one of the most useful property wrappers in SwiftUI, allowing us to create observable objects that
     automatically announce when changes occur. SwiftUI will automatically monitor for such changes, and re-invoke
     the body property of any views that rely on the data.
     
     In practical terms, that means whenever an object with a property marked @Published is changed, all views using
     that object will be reloaded to reflect those changes. **You can think of properties marked with @Published
     property wrapper as similar to the $emit event in Vue as they accomplish the same result in that they tell a
     "component" (a view in Swift) that some other "component" (in this case a ViewModel) has had a change in
     state that requires that other "component" to receive that change and in the case of Swift, reload the view.**
     (https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-published-property-wrapper)
     */
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    @Published var toastText: String?
    @Published var showStats = false
    @AppStorage("hardMode") var hardMode = false

    var keyColors = [String: Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var correctlyPlacedLetters = [String]()
    var targetWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    var gameOver = false
    var toastWinWords = ["Genius!", "Magnificent!", "Impressive!", "Good enough!", "A close one!", "Phew!"]
    var currentStat: Statistic
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0
    }
    var disabledKeys: Bool {
        !inPlay || currentWord.count == 5
    }

    init() {
        currentStat = Statistic.loadStat()
        newGame()
    }

    // MARK: - Setup
    func newGame() {
        populateDefaults()
        targetWord = AvailableWords.wordList.randomElement() ?? "HELLO"
        correctlyPlacedLetters = [String](repeating: "-", count: 5)
        currentWord = ""
        inPlay = true
        tryIndex = 0
        gameOver = false
        print(targetWord)
    }

    func populateDefaults() {
        guesses = []
        for index in 0...5 {
            guesses.append(Guess(index: index))
        }
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused
        }
        matchedLetters = []
        misplacedLetters = []
    }

    // MARK: - Game Play
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        updateRow()
    }

    func enterWord() {
        if currentWord == targetWord {
            gameOver = true
            setCurrentGuessColors()
            currentStat.update(win: true, index: tryIndex)
            showToast(with: toastWinWords[tryIndex])
            inPlay = false
        } else {
            if verifyWord() {
                if hardMode {
                    if let toastString = hardModeCorrectCheck() {
                        showToast(with: toastString)
                        return
                    }
                    if let toastString = hardModeMisplacedCheck() {
                        showToast(with: toastString)
                        return
                    }
                }
                setCurrentGuessColors()
                tryIndex += 1
                currentWord = ""
                if tryIndex == 6 {
                    currentStat.update(win: false)
                    gameOver = true
                    inPlay = false
                    showToast(with: "You lose, now get off my property. The correct word is \(targetWord).")
                }
            } else {
                withAnimation {
                    self.incorrectAttempts[tryIndex] += 1
                }
                showToast(with: "Not in word list")
                incorrectAttempts[tryIndex] = 0
            }
        }
    }

    func removeLastLetterFromCurrentWord() {
        currentWord.removeLast()
        updateRow()
    }

    func updateRow() {
        let guessWord = currentWord.padding(toLength: 5, withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }

    func verifyWord() -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord)
    }

    func hardModeCorrectCheck() -> String? {
        let guessLetters = guesses[tryIndex].guessLetters
        for i in 0...4 where correctlyPlacedLetters[i] != "-" && guessLetters[i] != correctlyPlacedLetters[i] {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                return "\(formatter.string(for: i + 1)!) letter must be `\(correctlyPlacedLetters[i])`."
            }
        return nil
    }

    func hardModeMisplacedCheck() -> String? {
        let guessLetters = guesses[tryIndex].guessLetters
        for letter in misplacedLetters where !guessLetters.contains(letter) {
            return ("Must contain the letter `\(letter)`.")
        }
        return nil
    }

    func setCurrentGuessColors() {
        let correctLetters = targetWord.map { String($0) }
        var frequency = [String: Int]()
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }

        for index in 0...4 {
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if guessLetter == correctLetter {
                guesses[tryIndex].bgColors[index] = .correct
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: { $0 == guessLetter }) {
                        misplacedLetters.remove(at: index)
                    }
                }
                correctlyPlacedLetters[index] = correctLetter
                frequency[guessLetter]! -= 1
            }
        }

        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correct
                && frequency[guessLetter]! > 0 {
                guesses[tryIndex].bgColors[index] = .misplaced
                if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter) {
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplaced
                }
                frequency[guessLetter]! -= 1
            }
        }
        wrongKeyColors()
        flipCards(for: tryIndex)
    }

    func wrongKeyColors() {
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if keyColors[guessLetter] != .correct && keyColors[guessLetter] != .misplaced {
                keyColors[guessLetter] = .wrong
            }
        }
    }

    func flipCards(for row: Int) {
        for col in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col) * 0.2) {
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }

    func showToast(with text: String?) {
        withAnimation {
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3.0)) {
            toastText = nil
            if gameOver {
                withAnimation(Animation.linear(duration: 0.2).delay(3.0)) {
                    showStats.toggle()
                }
            }
        }
    }

    func shareResult() {
        let stat = Statistic.loadStat()
        let results = guesses.enumerated().compactMap { $0 }
        var guessString = ""
        for result in results where result.0 <= tryIndex {
            guessString += result.1.results + "\n"
        }
        let resultString =
        """
        Wordle \(stat.games) \(tryIndex < 6 ? "\(tryIndex + 1)/6" : "")
        \(guessString)
        """
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2,
                                                                                  y: Global.screenHeight / 2,
                                                                                  width: 200, height: 200)
            UIWindow.key?.rootViewController!.present(activityController, animated: true)
        default:
            break
        }
    }
}
