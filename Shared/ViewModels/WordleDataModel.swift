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
     
     In practical terms, that means whenever an object with a property marked @Published is changed, all views using that object will be reloaded to reflect those changes. **You can think of properties marked with @Published property wrapper as similar
     to the $emit event in Vue as they accomplish the same result in that they tell a "component" (a view in Swift) that some other "component" (in this case a ViewModel) has had a change in state that requires that other "component" to receive that change and in the case of Swift, reload the view.**
     (https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-published-property-wrapper)
     */
    @Published var guesses: [Guess] = []
    
    init() {
        newGame()
    }
    
    func newGame() {
        populateDefaults()
    }
    
    func populateDefaults() {
        guesses = []
        for index in 0...5 {
            guesses.append(Guess(index: index))
        }
    }
}
