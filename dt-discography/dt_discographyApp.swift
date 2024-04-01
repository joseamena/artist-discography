//
//  dt_discographyApp.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import SwiftUI

@main
struct dt_discographyApp: App {
    let persistenceController = CoreDataPersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ArtistView()
        }
    }
}
