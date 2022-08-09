//
//  Color+Extension.swift
//  WordleClone
//
//  Created by Rob Ranf on 7/17/22.
//

import SwiftUI

extension Color {
    static var wrong: Color {
        Color(UIColor(named: "wrong") ?? .red)
    }
    static var misplaced: Color {
        Color(UIColor(named: "misplaced") ?? .red)
    }
    static var correct: Color {
        Color(UIColor(named: "correct") ?? .red)
    }
    static var unused: Color {
        Color(UIColor(named: "unused") ?? .red)
    }
    static var notAWord: Color {
        Color(UIColor(named: "notAWord") ?? .red)
    }
    static var systemBackground: Color {
        Color(.systemBackground)
    }
}
