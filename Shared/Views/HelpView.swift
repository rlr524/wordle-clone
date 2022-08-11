//
//  HelpView.swift
//  WordleClone
//
//  Created by Rob Ranf on 8/11/22.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(
"""
Guess the **WORDLE** in six tries.

Each guess must be a valid five letter word. Hit the **ENTER** button to submit.

After each guess, the color of the tiles will change to show how close your guess was to the word.
"""
                )
                Divider().frame(height: 2.0).overlay(.black)
                Text("Examples")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Image("Weary")
                        .resizable()
                        .scaledToFit()
                    Text("The letter **W** is in the word and in the correct spot.")
                    Image("Pills")
                        .resizable()
                        .scaledToFit()
                    Text("The letter **I** is in the word, but not in the correct spot.")
                    Image("Vague")
                        .resizable()
                        .scaledToFit()
                    Text("The letter **U** is not in the word in any spot.")
                    Divider().frame(height: 2.0).overlay(.black)
                    if Global.screenHeight < 600 {
                        Text("Tap the NEW button for a new WORDLE")
                            .font(.system(size: 14.0))
                            .fontWeight(.bold)
                    } else {
                        Text("Tap the NEW button for a new WORDLE")
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(width: min(Global.screenWidth - 40, 350))
            .navigationTitle("HOW TO PLAY")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("X")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
