//
//  ArtistViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import CoreData
import Foundation

@MainActor
class ArtistViewModel: ObservableObject {
    // MARK: - Private properties -

    private let client: NetworkClient
    private let persistenceController: PersistenceController

    // MARK: - Outputs -

    @Published var loadStatus = LoadStatus.none
    @Published var artistName = ""
    @Published var profile = ""
    @Published var primaryImageUrl: URL?
    @Published var secondaryImageUrl: URL?
    @Published var currentMembers: String?
    @Published var urls: [String] = []

    // MARK: - Initialization -

    init(client: NetworkClient, persistenceController: PersistenceController) {
        self.client = client
        self.persistenceController = persistenceController
    }

    // MARK: - Public Functions -

    func fetchArtist() async {
        loadStatus = .loading
        let artist: Artist

        do {
            if client.connectivity {
                artist = try await networkFetch(artistId: "\(DTConfiguration.artistId)")
                persistenceController.saveArtist(artist: artist)
            } else {
                artist = try persistenceController.fetchArtist(with: "\(DTConfiguration.artistId)")
            }
            loadStatus = .none
        } catch {
            loadStatus = .error(error)
            return
        }

        if let primaryImage = artist.imageUrl {
            primaryImageUrl = URL(string: primaryImage)
        }

        artistName = artist.name
        profile = artist.profile
            .replacingOccurrences(of: "a=", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
        currentMembers = artist.currentMembers
        urls = artist.urls ?? []
    }

    // MARK: - Private Functions -

    private func networkFetch(artistId: String) async throws -> Artist {
        let artistTarget = ArtistTarget(artistId: artistId)

        let artistResponse = try await client.buildRequest(target: artistTarget, type: ArtistResponse.self, ignoreCache: false)

        let imageUrl = artistResponse.images.first(where: { $0.type == "secondary" })?.uri

        return Artist(
            id: artistResponse.id,
            name: artistResponse.name,
            profile: artistResponse.profile,
            imageUrl: imageUrl,
            urls: artistResponse.urls
        )
    }
}
