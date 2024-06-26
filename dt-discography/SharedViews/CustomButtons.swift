//
//  CustomButtons.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body).bold()
            .padding()
            .background(LinearGradient.accent)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: 0.1)
    }
}

struct ErrorButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body).bold()
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient.error)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: 0.1)
    }
}

#Preview {
    Group {
        Button(action: {}, label: { Text("Some Button") })
            .buttonStyle(PrimaryButton())
        Button(action: {}, label: { Text("Some Error Button") })
            .buttonStyle(ErrorButton())
    }
}
