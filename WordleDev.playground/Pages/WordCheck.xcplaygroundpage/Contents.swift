//: [Previous](@previous)

import Foundation

// swiftlint:disable all
enum Color: String {
case correct, misplaced, wrong
    var prefix: String {
        String(self.rawValue.prefix(1)).capitalized
    }
}

struct Guess {
    let index: Int
    var word = " " + " " + " " + " " + " "
    var bgColors = [Color](repeating: .wrong, count: 5)
    var cardFlipped = [Bool](repeating: false, count: 5)
    var guessLetters: [String] {
        word.map { String($0) }
    }
    var matchedLetters: String {
        bgColors.map {$0.prefix}.joined(separator: "")
    }
}

let targetWord = "BONDS"
let tryIndex = 0

var guesses = [Guess]()
for index in 0...5 {
    guesses.append(Guess(index: index))
}

guesses[tryIndex].word = "BOOKS"

func setCurrentGuessColors() {
    let correctLetters = targetWord.map { String($0) }
    var frequency = [String : Int]()
    for letter in correctLetters {
        frequency[letter, default: 0] += 1
    }
    for index in 0...4 {
        let correctLetter = correctLetters[index]
        let guessLetter = guesses[tryIndex].guessLetters[index]
        if guessLetter == correctLetter {
            guesses[tryIndex].bgColors[index] = .correct
            frequency[guessLetter]! -= 1
        }
    }
    for index in 0...4 {
        let guessLetter = guesses[tryIndex].guessLetters[index]
        if correctLetters.contains(guessLetter)
            && guesses[tryIndex].bgColors[index] != .correct
            && frequency[guessLetter]! > 0 {
            guesses[tryIndex].bgColors[index] = .misplaced
            frequency[guessLetter]! -= 1
        }
    }
    print(targetWord)
    print(guesses[tryIndex].word)
    print(guesses[tryIndex].matchedLetters)
}

setCurrentGuessColors()
