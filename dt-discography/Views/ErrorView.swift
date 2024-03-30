//
//  ErrorView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/29/24.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let action: () -> Void

    var body: some View {
        VStack {
            Text(error.localizedDescription)
                .font(.title)
            Text((error as? LocalizedError)?.recoverySuggestion ?? "")

            Button("Retry", action: action)
                .buttonStyle(ErrorButton())
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .primary, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ErrorView(error: AppError.unknown, action: {})
}
