//
//  Keyboard.swift
//  WordleClone
//
//  Created by Robert Ranf on 7/20/22.
//

import SwiftUI

struct Keyboard: View {
    @EnvironmentObject var dm: WordleDataModel
    // Using shorthand argument names; map takes a closure as its argument (because it's only one argument, we can remove the () that enclose arguments). In this case, our shorthand argument names in middleRowArray and bottomRowArray are the same as how topRowArray is written.
    var topRowArray = "QWERTYUIOP".map({char in
        String(char) //Same thing as saying "QWERTYUIOP"[char] or, in a correct syntax, first assigning "QWERTYUIOP" to varName then varName[char]
    })
    var middleRowArray = "ASDFGHJKL".map{ String($0) }
    var bottomRowArray = "ZXCVBNM".map{ String($0) }
        var body: some View {
            VStack {
                HStack(spacing: 2) {
                    ForEach(topRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                    .disabled(dm.disabledKeys)
                    .opacity(dm.disabledKeys ? 0.6 : 1)
                }
                HStack(spacing: 2) {
                    ForEach(middleRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                    .disabled(dm.disabledKeys)
                    .opacity(dm.disabledKeys ? 0.6 : 1)
                }
                HStack(spacing: 2) {
                    Button {
                        dm.enterWord()
                    } label: {
                        Text("Enter")
                    }
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 60, height: 50)
                    .foregroundColor(.primary)
                    .background(Color.unused)
                    .disabled(dm.currentWord.count < 5 || !dm.inPlay)
                    .opacity((dm.currentWord.count < 5 || !dm.inPlay) ? 0.6 : 1)
                    ForEach(bottomRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                    .disabled(dm.disabledKeys)
                    .opacity(dm.disabledKeys ? 0.6 : 1)
                    Button {
                        dm.removeLastLetterFromCurrentWord()
                    } label: {
                        Image(systemName: "delete.backward.fill")
                            .font(.system(size: 20, weight: .heavy))
                            .frame(width: 40, height: 50)
                            .foregroundColor(.primary)
                            .background(Color.unused)
                    }
                    .disabled(!dm.inPlay || dm.currentWord.count == 0)
                    .opacity((!dm.inPlay || dm.currentWord.count == 0) ? 0.6 : 1)
                }
            }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
            .environmentObject(WordleDataModel())
            .scaleEffect(Global.keyboardScale)
    }
}
