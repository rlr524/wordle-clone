//
//  Keyboard.swift
//  WordleClone
//
//  Created by Robert Ranf on 7/20/22.
//

import SwiftUI

struct Keyboard: View {
    @EnvironmentObject var dm: WordleDataModel
    var topRowArray = "QWERTYUIOP".map{ String($0) }
    var middleRowArray = "ASDFGHJKL".map{ String($0) }
    var bottomRowArray = "ZXCVBNM".map{ String($0) }
        var body: some View {
            VStack {
                HStack(spacing: 2) {
                    ForEach(topRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                }
                HStack(spacing: 2) {
                    ForEach(middleRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
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
                    ForEach(bottomRowArray, id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                    Button {
                        dm.removeLastLetterFromCurrentWord()
                    } label: {
                        Image(systemName: "delete.backward.fill")
                    }
                    .font(.system(size: 20, weight: .heavy))
                    .frame(width: 40, height: 50)
                    .foregroundColor(.primary)
                    .background(Color.unused)
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
