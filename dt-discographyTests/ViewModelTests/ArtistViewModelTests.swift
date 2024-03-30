//
//  ArtistViewModelTests.swift
//  dt-discographyTests
//
//  Created by Jose A. Mena on 3/30/24.
//

@testable import dt_discography
import XCTest

final class ArtistViewModelTests: XCTestCase {
    private var artistViewModel: ArtistViewModel!
    private let mockNetworkClient = MockNetworkClient()

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        artistViewModel = ArtistViewModel(client: mockNetworkClient)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testFetchArtistError() async throws {
        _ = await artistViewModel.fetchArtist()
        XCTAssert(artistViewModel.loadStatus == .error(AppError.unknown))
    }

    @MainActor func testFetchArtistSuccess() async throws {
        mockNetworkClient.mockValue = ArtistResponse(
            name: "Jose",
            id: 0,
            resourceUrl: "https://",
            uri: "https://",
            releasesUrl: "https://",
            images: [],
            profile: "profile",
            urls: nil,
            members: nil
        )
        _ = await artistViewModel.fetchArtist()
        XCTAssert(artistViewModel.loadStatus == .none)
    }
}
