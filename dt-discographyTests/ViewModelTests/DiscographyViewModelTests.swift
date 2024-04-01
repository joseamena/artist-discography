//
//  DiscographyViewModelTests.swift
//  dt-discographyTests
//
//  Created by Jose A. Mena on 3/30/24.
//

@testable import dt_discography
import XCTest

final class DiscographyViewModelTests: XCTestCase {
    private var discographyViewModel: DiscographyViewModel!
    private let mockNetworkClient = MockNetworkClient()

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        discographyViewModel = DiscographyViewModel(client: mockNetworkClient, persistenceController: MockPersistenceController())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testFetchReleasesError() async throws {
        _ = await discographyViewModel.fetchReleases()
        XCTAssert(discographyViewModel.loadStatus == .error(AppError.unknown))
    }

    @MainActor func testFetchReleasesSuccess() async throws {
        mockNetworkClient.mockValue = ArtistReleasesResponse(
            pagination: ArtistReleasesResponse.Pagination(
                page: 0,
                pages: 0,
                perPage: 3,
                items: 2,
                urls: ArtistReleasesResponse.Urls(last: nil, next: nil)
            ),
            releases: []
        )
        _ = await discographyViewModel.fetchReleases()
        XCTAssert(discographyViewModel.loadStatus == .none)
    }
}
