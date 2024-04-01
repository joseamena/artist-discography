//
//  ReleaseDetailView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Kingfisher
import SwiftUI

struct ReleaseDetailView: View {
    @StateObject private var viewModel = ReleaseDetailsViewModel(
        client: DTDiscographyClient.shared,
        persistentController: CoreDataPersistenceController.shared
    )

    let release: Release

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
        .task {
            await viewModel.fetchReleaseDetails(release: release)
        }
    }

    private var content: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                title
                image
                    .padding(.bottom)
                maybeTrackListing
                    .padding(.bottom)
                maybeRating
                Spacer()
            }
        }
        .padding(.horizontal)
    }

    private var image: some View {
        KFImage(viewModel.imageUrl)
            .placeholder { progress in
                ProgressView(progress)
            }
            .onFailureImage(UIImage(named: "cd"))
            .resizable()
            .aspectRatio(
                imageAspectRatio,
                contentMode: .fit
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
    }

    private var title: some View {
        HStack {
            Text(viewModel.title).font(.title2).bold()
            Spacer()
        }
    }

    @ViewBuilder
    private var maybeTrackListing: some View {
        if !viewModel.trackListing.isEmpty {
            VStack {
                HStack {
                    Text("Track Listing").font(.title2).bold()
                    Spacer()
                }
                .background(
                    LinearGradient.accent
                        .opacity(0.6)
                )

                ForEach(viewModel.trackListing) { track in
                    HStack {
                        Text("\(track.title)")
                        Spacer()
                        Text(track.duration)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var maybeRating: some View {
        if let rating = viewModel.rating {
            HStack {
                Text("Rating:")
                RatingView(rating: rating)
                Spacer()
            }
        }
    }

    // MARK: - Behavior -

    private func errorRetryButtonPressed() {
        Task {
            await viewModel.fetchReleaseDetails(release: release)
        }
    }

    // MARK: - Helpers -

    private var imageAspectRatio: CGFloat {
        // Protect against division by 0
        guard viewModel.imageSize.height > 0 else {
            return 1
        }
        return viewModel.imageSize.width / viewModel.imageSize.height
    }
}

#Preview {
    ReleaseDetailView(
        release: Release(
            id: 0,
            mainRelease: 0,
            format: "12\", Maxi",
            title: "Title",
            label: "Capitol",
            resourceUrl: "https://api.discogs.com/releases/3930221",
            year: 1500,
            thumb: "https://i.discogs.com/otrB6zRwRDNhznIkjQ5_DwLO3dNjNvWxdbYV4g6tXTs/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTkwNDc1/NjEtMTQ3Mzg1NzUz/NS01Mzc0LmpwZWc.jpeg"
        )
    )
}
