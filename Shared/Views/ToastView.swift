//
//  ToastView.swift
//  WordleClone
//
//  Created by Rob Ranf on 8/4/22.
//

import SwiftUI

// - TODO: 2022-08-04 - Refactor so the ToastView fill takes in a color as an argument based on the view message.
struct ToastView: View {
    let toastText: String
    var body: some View {
        Text(toastText)
            .foregroundColor(.systemBackground)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.primary))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(toastText: "Not in word list")
    }
}
