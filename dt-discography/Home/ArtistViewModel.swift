//
//  ArtistViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Combine
import Foundation

@MainActor
class ArtistViewModel: ObservableObject {
    // MARK: - Private properties -

    private let client: NetworkClient

    // MARK: - Outputs -

    @Published var loadStatus = LoadStatus.none
    @Published var artistName = ""
    @Published var profile = ""
    @Published var primaryImageUrl: URL?
    @Published var secondaryImageUrl: URL?
    @Published var currentMembers: String?
    @Published var urls: [String] = []

    // MARK: - Initialization -

    init(client: NetworkClient) {
        self.client = client
    }

    // MARK: - Data Fetching -

    func fetchArtist() async {
        let artistTarget = ArtistTarget(artistId: "335835")
        loadStatus = .loading

        do {
            let artistResponse = try await client.buildRequest(target: artistTarget, type: ArtistResponse.self)
            loadStatus = .none
            if let primaryImage = artistResponse.images.first(where: { $0.type == "secondary" })?.uri {
                primaryImageUrl = URL(string: primaryImage)
            }
            artistName = artistResponse.name
            profile = artistResponse.profile
                .replacingOccurrences(of: "a=", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
            currentMembers = artistResponse
                .members?
                .filter { $0.active }
                .map { $0.name }.joined(separator: ", ")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            urls = artistResponse.urls ?? []
        } catch {
            loadStatus = .error(error)
        }
    }
}
