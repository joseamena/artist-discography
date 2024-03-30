//
//  ArtistView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Kingfisher
import SwiftUI

struct ArtistView: View {
    // MARK: - Private Properties -

    @StateObject private var viewModel = ArtistViewModel(client: DTDiscographyClient.shared)
    @State private var navigationPath = NavigationPath()

    // MARK: - UI Content -

    var body: some View {
        // If More screens require the same pattern look into
        // refactoring by create a wrapper view to show loading status or content
        Group {
            switch viewModel.loadStatus {
            case .loading:
                ProgressView()
            case let .error(error):
                ErrorView(error: error, action: errorRetryButtonPressed)
            case .none:
                content
            }
        }
        .task(priority: .background) {
            await viewModel.fetchArtist()
        }
    }

    private var content: some View {
        NavigationStack(path: $navigationPath) {
            VStack(alignment: .leading, spacing: 0) {
                artistImage
                artistDetails
                Spacer()
            }
            .ignoresSafeArea()
            .navigationTitle(viewModel.artistName)
            .navigationBarHidden(true)
            .navigationDestination(for: Int.self) { _ in // TODO: Find a better way to navigate programatically
                DiscographyView()
            }
        }
    }

    private var artistDetails: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                summary
                viewDiscographyButton.padding(.bottom)
                links
            }
        }
        .padding()
    }

    private var viewDiscographyButton: some View {
        Button(action: discographyButtonPressed) {
            HStack {
                Text("Discography")
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(PrimaryButton())
    }

    private var artistImage: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(viewModel.primaryImageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .clear, location: 1),
                            ]
                        ),
                        startPoint: .top, endPoint: .bottom
                    )
                )
            Text(viewModel.artistName)
                .font(.title)
                .bold()
                .padding(.leading)
        }
    }

    private var summary: some View {
        VStack(alignment: .leading) {
            Text(viewModel.profile).font(.body)
                .padding(.bottom)
            maybeCurrentMembers
                .padding(.bottom)
        }
    }

    @ViewBuilder
    private var maybeCurrentMembers: some View {
        if let currentMembers = viewModel.currentMembers {
            Text("Current Members: \(currentMembers)")
        }
    }

    private var links: some View {
        VStack(alignment: .leading) {
            Text("Links:")
            ForEach(viewModel.urls, id: \.self) { link in
                Button(action: { linkButtonPressed(link: link) }) {
                    Text(link).font(.body)
                }
            }
        }
    }

    // MARK: - Behavior -

    private func linkButtonPressed(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }

    private func discographyButtonPressed() {
        navigationPath.append(0)
    }

    private func errorRetryButtonPressed() {
        Task {
            await viewModel.fetchArtist()
        }
    }
}

#Preview {
    ArtistView()
        .preferredColorScheme(.dark)
}
