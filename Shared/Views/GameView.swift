//
//  GameView.swift
//  Shared
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm: WordleDataModel
    @State private var showSettings = false
    @State private var showHelp = false
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if Global.screenHeight < 600 {
                        Text("")
                    }
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
                .disabled(dm.showStats)
                .navigationBarTitleDisplayMode(.inline)
                .overlay(alignment: .top) {
                    if let toastText = dm.toastText {
                        ToastView(toastText: toastText)
                            .offset(y: 20)
                    }
                }
                .toolbar {
                    ToolbarItem(id: "help", placement: .navigationBarLeading, showsByDefault: true) {
                        HStack {
                            if !dm.inPlay {
                                Button {
                                    dm.newGame()
                                } label: {
                                    Text("New")
                                        .foregroundColor(.primary)
                                }
                            }
                            Button {
                                showHelp.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    ToolbarItem(id: "title", placement: .principal, showsByDefault: true) {
                        Text("WORDLE")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(dm.hardMode ? Color(.systemRed) : .primary)
                            .minimumScaleFactor(0.5)
                    }
                    ToolbarItem(id: "menus", placement: .navigationBarTrailing, showsByDefault: true) {
                        HStack {
                            Button {
                                withAnimation {
                                    dm.currentStat = Statistic.loadStat()
                                    dm.showStats.toggle()
                                }
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape.fill")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showHelp) {
                    HelpView()
                }
            }
            if dm.showStats {
                StatsView()
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
