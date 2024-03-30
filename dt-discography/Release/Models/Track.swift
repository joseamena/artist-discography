//
//  Track.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

struct Track: Hashable, Identifiable {
    let position: String
    let title: String
    let duration: String

    var id: String {
        position + title + duration
    }
}
