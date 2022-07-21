//
//  GameView.swift
//  Shared
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm: WordleDataModel
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                VStack(spacing: 3) {
                    ForEach(0...5, id: \.self) { index in
                        GuessView(guess: $dm.guesses[index])
                            .modifier(Shake(animatableData: CGFloat(dm.incorrectAttempts[index])))
                    }
                }
                .frame(width: Global.boardWidth, height: (6 * Global.boardWidth) / 5)
                Spacer()
                Keyboard()
                    .scaleEffect(Global.keyboardScale)
                    .padding(.top)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(id: "help", placement: .navigationBarLeading, showsByDefault: true) {
                    Button {
                        
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
            }
                ToolbarItem(id: "title", placement: .principal, showsByDefault: true) {
                    Text("WORDLE")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                }
                ToolbarItem(id: "menus", placement: .navigationBarTrailing, showsByDefault: true) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "chart.bar")
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    
                }
    }
}
        .navigationViewStyle(.stack)
}
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
            .previewInterfaceOrientation(.portrait)
        GameView()
            .environmentObject(WordleDataModel())
            .preferredColorScheme(.dark)
    }
}
