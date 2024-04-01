//
//  ReleaseDetailsViewModelTests.swift
//  dt-discographyTests
//
//  Created by Jose A. Mena on 3/30/24.
//

@testable import dt_discography
import XCTest

final class ReleaseDetailsViewModelTests: XCTestCase {
    private var releaseDetailsViewModel: ReleaseDetailsViewModel!
    private let mockNetworkClient = MockNetworkClient()

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        releaseDetailsViewModel = ReleaseDetailsViewModel(
            client: mockNetworkClient,
            persistentController: MockPersistenceController()
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testFetchReleasesError() async throws {
        _ = await releaseDetailsViewModel.fetchReleaseDetails(release: .mock)
        XCTAssert(releaseDetailsViewModel.loadStatus == .error(AppError.unknown))
    }

    @MainActor func testFetchReleasesSuccess() async throws {
        mockNetworkClient.mockValue = ReleaseResponse(
            id: 0,
            title: "amazing",
            year: 0,
            tracklist: [],
            images: [],
            formats: nil,
            genres: [],
            styles: [],
            community: nil
        )
        _ = await releaseDetailsViewModel.fetchReleaseDetails(release: .mock)
        XCTAssert(releaseDetailsViewModel.loadStatus == .none)
    }
}
