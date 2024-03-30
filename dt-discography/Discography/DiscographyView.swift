//
//  DiscographyView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import SwiftUI

struct DiscographyView: View {
    // MARK: - Properties -

    @StateObject private var viewModel = DiscographyViewModel(client: DTDiscographyClient.shared)

    // MARK: - UIContent -

    var body: some View {
        // If More screens require the same pattern look into
        // refactoring by create a wrapper view to show loading status or content
        Group {
            switch viewModel.loadStatus {
            case .loading:
                ProgressView()
            case let .error(error):
                ErrorView(error: error, action: {})
            case .none:
                content
            }
        }
        .task(priority: .background) {
            await viewModel.fetchReleases()
        }
    }

    private var content: some View {
        discographyList
            .navigationTitle("Discography")
            .navigationDestination(for: Release.self) { release in
                ReleaseDetailView(release: release)
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

    // MARK: - Behavior -

    private func errorRetryButtonPressed() {
        Task {
            await viewModel.fetchReleases()
        }
    }
}

// MARK: - Previews -

#Preview {
    DiscographyView()
}
