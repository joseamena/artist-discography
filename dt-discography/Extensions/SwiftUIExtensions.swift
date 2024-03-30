//
//  SwiftUIExtensions.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/29/24.
//

import SwiftUI

extension LinearGradient {
    static var accent: LinearGradient {
        LinearGradient(
            colors: [
                Color.teal,
                Color.blue,
                Color.indigo,
            ],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }

    static var error: LinearGradient {
        LinearGradient(
            colors: [
                Color.pink,
                Color.red,
                Color.magenta,
            ],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

extension Color {
    static var magenta: Color {
        Color(red: 203 / 255, green: 31 / 255, blue: 80 / 255)
    }
}
