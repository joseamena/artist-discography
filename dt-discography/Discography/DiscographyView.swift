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
        discographyList
            .navigationTitle("Discography")
            .navigationDestination(for: Release.self) { release in
                ReleaseDetailView(release: release)
            }
            .task(priority: .background) {
                await viewModel.fetchReleases()
            }
    }

    private var discographyList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.releases) { release in
                    NavigationLink(value: release) {
                        ReleaseCardView(release: release)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    DiscographyView()
}
