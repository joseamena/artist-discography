//
//  DiscographyViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

@MainActor
class DiscographyViewModel: ObservableObject {
    // MARK: - Private properties -

    private let client: NetworkClient
    private let persistenceController: PersistenceController

    // MARK: - Outputs -

    @Published var loadStatus = LoadStatus.none
    @Published var releases: [Release] = []

    // MARK: - Initialization -

    init(client: NetworkClient, persistenceController: PersistenceController) {
        self.client = client
        self.persistenceController = persistenceController
    }

    // MARK: - Data Fetching -

    func fetchReleases() async {
        loadStatus = .loading

        do {
            if client.connectivity {
                releases = try await networkFetch(artistId: "\(DTConfiguration.artistId)")
                persistenceController.saveReleases(releases: releases, for: "\(DTConfiguration.artistId)")
            } else {
                releases = try persistenceController.fetchReleases(for: "\(DTConfiguration.artistId)")
            }
            loadStatus = .none
        } catch {
            loadStatus = .error(error)
            return
        }
    }

    // MARK: - Private Functions -

    private func networkFetch(artistId: String) async throws -> [Release] {
        let releasesTarget = ReleasesTarget(artistId: artistId)

        let releasesResponse = try await client.buildRequest(
            target: releasesTarget,
            type: ArtistReleasesResponse.self,
            ignoreCache: false
        )
        return releasesResponse.releases.map {
            Release(
                id: $0.id,
                mainRelease: $0.mainRelease,
                format: $0.format,
                title: $0.title,
                label: $0.label,
                resourceUrl: $0.resourceUrl,
                year: $0.year,
                thumb: $0.thumb
            )
        }
    }
}
