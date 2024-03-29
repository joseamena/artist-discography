//
//  RatingView.swift
//  dt-discography
//
//  Created by bacanador on 3/29/24.
//

import SwiftUI

// Code Snippet Taken from
// https://www.hackingwithswift.com/books/ios-swiftui/adding-a-custom-star-rating-component

struct RatingView: View {
    let rating: Int
    let maximumRating = 5
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Image(systemName: "star.fill")
                    .foregroundStyle(number > rating ? offColor : onColor)
            }
        }
    }
}

#Preview {
    RatingView(
        rating: 4
    )
}
