//
//  ArtistViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation
import Combine

@MainActor
class ArtistViewModel: ObservableObject {

    // MARK: - Private properties -
    private let client: NetworkClient
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Outputs -
    @Published var loadStatus = LoadStatus.none
    @Published var artistName = ""
    @Published var primaryImageUrl: URL?
    @Published var secondaryImageUrl: URL?
    @Published var currentMembers: String = ""
    
    init(client: NetworkClient) {
        self.client = client
        
        fetchArtist()
    }
    
    private func fetchArtist() {
        let target = ArtistTarget(artistId: "260935")
        
        loadStatus = .loading
        client.buildRequest(target: target, type: ArtistResponse.self)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.loadStatus = .error(error)
                case .finished:
                    self?.loadStatus = .none
                }
            } receiveValue: { [weak self] artistResponse in
                self?.artistName = artistResponse.name
                if let primaryImage = artistResponse.images.first(where: { $0.type == "primary" } )?.uri {
                    self?.primaryImageUrl = URL(string: primaryImage)
                }
                self?.currentMembers = artistResponse
                    .members
                    .filter { $0.active }
                    .map { $0.name }.joined(separator: ", ")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .store(in: &cancellables)
    }
    
}
