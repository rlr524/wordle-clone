//
//  Flip.swift
//  WordleClone
//
//  Created by Rob Ranf on 8/3/22.
//

import SwiftUI

struct Flip<Front, Back>: View where Front: View, Back: View {
    // This is an instance variable, we're creating an instance of the Binding struct and naming it isFlipped; it can
    // also be thought of as a Binding wrapper around isFlipped. Below, when we init our Flip struct, we need to init
    // isFlipped with in underscore to indicate that we're assigning isFlipped to the wrapper (the Binding struct
    // itself) which has a type of Binding<Bool>, not to the instance, which just has a type of Bool.
    @Binding var isFlipped: Bool
    var front: () -> Front
    var back: () -> Back
    @State var flipped: Bool = false
    @State var cardRotation = 0.0
    @State var contentRotation = 0.0

    init(isFlipped: Binding<Bool>,
         @ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
        self._isFlipped = isFlipped
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            if flipped {
                back()
            } else {
                front()
            }
        }
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 1, y: 0, z: 0))
        .onChange(of: isFlipped) { _ in
            flipCard()
        }
        .rotation3DEffect(.degrees(cardRotation), axis: (x: 1, y: 0, z: 0))
    }

    func flipCard() {
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime)) {
            cardRotation += -180
        }
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += -180
            flipped.toggle()
        }
    }
}
