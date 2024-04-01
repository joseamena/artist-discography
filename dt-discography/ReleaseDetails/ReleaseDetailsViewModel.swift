//
//  ReleaseDetailsViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

@MainActor
class ReleaseDetailsViewModel: ObservableObject {
    // MARK: - Private properties -

    private let client: NetworkClient
    private let persistenceController: PersistenceController

    // MARK: - Outputs -

    @Published var loadStatus = LoadStatus.none
    @Published var imageUrl: URL?
    @Published var imageSize: CGSize = .zero
    @Published var title: String = ""
    @Published var trackListing: [Track] = []
    @Published var rating: Int?

    // MARK: - Initialization -

    init(client: NetworkClient, persistentController: PersistenceController) {
        self.client = client
        persistenceController = persistentController
    }

    // MARK: - Data Fetching -

    func fetchReleaseDetails(release: Release) async {
        loadStatus = .loading
        let releaseDetails: ReleaseDetails
        do {
            if client.connectivity {
                releaseDetails = try await networkFetch(url: release.resourceUrl)
                persistenceController.saveReleaseDetails(releaseDetails: releaseDetails)
            } else {
                releaseDetails = try persistenceController.fetchReleaseDetails(with: "\(release.id)")
            }
            loadStatus = .none
        } catch {
            loadStatus = .error(error)
            return
        }

        title = releaseDetails.title
        imageUrl = URL(string: releaseDetails.imageUrl ?? "")
        imageSize = releaseDetails.imageSize
        trackListing = releaseDetails.tracks
        rating = releaseDetails.rating
    }

    private func networkFetch(url: String) async throws -> ReleaseDetails {
        let releaseTarget = ReleaseTarget(path: url)

        let releaseResponse = try await client.buildRequest(
            target: releaseTarget,
            type: ReleaseResponse.self,
            ignoreCache: false
        )

        let imageData = releaseResponse.images.first(where: { $0.type == "primary" }) ?? releaseResponse.images.first
        let tracks = releaseResponse.tracklist
            .map {
                Track(
                    position: $0.position,
                    title: $0.title,
                    duration: $0.duration
                )
            }
            .removingDuplicates()

        return ReleaseDetails(
            id: releaseResponse.id,
            imageUrl: imageData?.uri,
            imageSize: CGSize(width: imageData?.width ?? 0, height: imageData?.height ?? 0),
            title: releaseResponse.title,
            rating: Int(ceil(releaseResponse.community?.rating.average ?? 0)),
            tracks: tracks
        )
    }
}
