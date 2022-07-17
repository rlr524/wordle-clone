//
//  WordleCloneApp.swift
//  Shared
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

@main
struct WordleCloneApp: App {
    @StateObject var dm = WordleDataModel()
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)
        }
    }
}
