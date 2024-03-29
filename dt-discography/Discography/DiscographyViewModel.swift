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

    // MARK: - Outputs -
    @Published var loadStatus = LoadStatus.none
    @Published var releases: [Release] = []
    
    // MARK: - Initialization -
    init(client: NetworkClient) {
        self.client = client
    }
    
    func fetchReleases() async {
        let releasesTarget = ReleasesTarget(artistId: "335835")
        loadStatus = .loading
        
        do {
            let releasesResponse = try await client.buildRequest(target: releasesTarget, type: ArtistReleasesResponse.self)
            loadStatus = .none
            releases = releasesResponse.releases.map {
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
        } catch {
            loadStatus = .error(error)
        }
    }
}
