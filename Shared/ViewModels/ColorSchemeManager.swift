//
//  ColorSchemeManager.swift
//  WordleClone
//
//  Created by Rob Ranf on 8/10/22.
//

import SwiftUI

enum ColorScheme: Int {
    case unspecified, light, dark
}

class ColorSchemeManager: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: ColorScheme = .unspecified {
        didSet {
            applyColorScheme()
        }
    }

    func applyColorScheme() {
        UIWindow.key?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue) ?? .unspecified
    }
}
