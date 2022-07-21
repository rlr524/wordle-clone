//
//  WordleDataModel.swift
//  WordleClone
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

class WordleDataModel: ObservableObject {
    /**
     @Published is one of the most useful property wrappers in SwiftUI, allowing us to create observable objects that automatically announce when changes occur. SwiftUI will automatically monitor for such changes, and re-invoke the body property of any views that rely on the data.
     
     In practical terms, that means whenever an object with a property marked @Published is changed, all views using that object will be reloaded to reflect those changes. **You can think of properties marked with @Published property wrapper as similar to the $emit event in Vue as they accomplish the same result in that they tell a "component" (a view in Swift) that some other "component" (in this case a ViewModel) has had a change in state that requires that other "component" to receive that change and in the case of Swift, reload the view.**
     (https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-published-property-wrapper)
     */
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    
    var keyColors = [String: Color]()
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool {
        !inPlay || currentWord.count == 5
    }
    
    
    init() {
        newGame()
    }
    
    //MARK: - Setup
    func newGame() {
        populateDefaults()
        selectedWord = Global.availableWords.randomElement()!
        currentWord = ""
        inPlay = true
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
    }
    
    //MARK: - Game Play
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        updateRow()
    }
    
    func enterWord() {
        if verifyWord() {
            let _ = print("Valid word")
        } else {
            withAnimation {
                self.incorrectAttempts[tryIndex] += 1
            }
            incorrectAttempts[tryIndex] = 0
            let _ = print("Invalid word")
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
}
