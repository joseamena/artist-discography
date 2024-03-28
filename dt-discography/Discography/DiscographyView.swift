//
//  DiscographyView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import SwiftUI

struct DiscographyView: View {
    
    @StateObject private var viewModel = DiscographyViewModel(client: DTDiscographyClient())
    
    var body: some View {
        NavigationStack {
            discographyList
        }
        .task(priority: .background) {
            await viewModel.fetchReleases()
        }
    }
    
    private var discographyList: some View {
        List(viewModel.releases) { release in
            return Text(release.title)
        }
    }
}

#Preview {
    DiscographyView()
}
