//
//  ShapeStyle+Helpers.swift
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
}
