//
//  ReleaseDetailViewModel.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

@MainActor
class ReleaseDetailViewModel: ObservableObject {
    // MARK: - Private properties -
    private let client: NetworkClient

    // MARK: - Outputs -
    @Published var loadStatus = LoadStatus.none
    @Published var imageUrl: URL?
    @Published var title: String = ""
    @Published var trackListing: [Track] = []
    @Published var rating: Int?
    
    // MARK: - Initialization -
    init(client: NetworkClient) {
        self.client = client
    }
    
    func fetchReleaseDetails(uri: String) async {
        let releaseTarget = ReleaseTarget(path: uri)
        loadStatus = .loading
        
        do {
            let releaseResponse = try await client.buildRequest(target: releaseTarget, type: ReleaseResponse.self)
            loadStatus = .none
            
            if let imageData = releaseResponse.images.first(where: { $0.type == "primary"}) ?? releaseResponse.images.first {
                imageUrl = URL(string: imageData.uri)
            }
            
            title = releaseResponse.title
            trackListing = releaseResponse.tracklist.map {
                Track(
                    position: $0.position,
                    title: $0.title,
                    duration: $0.duration
                )
            }
    
            if let ratingAverage = releaseResponse.community?.rating.average {
                print(ratingAverage)
                rating = Int(ceil(ratingAverage))
            }
        } catch {
            print(error)
            loadStatus = .error(error)
        }
    }
}
