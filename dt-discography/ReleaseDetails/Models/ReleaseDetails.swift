//
//  ReleaseDetails.swift
//  dt-discography
//
//  Created by bacanador on 4/1/24.
//

import Foundation

struct ReleaseDetails {
    let id: Int
    let imageUrl: String?
    let imageSize: CGSize
    let title: String
    let rating: Int?
    let tracks: [Track]
}
