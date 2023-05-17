//
//  NetworkControllerTests.swift
//  IntegrationTests
//
//  Created by Bálna on 2023. 05. 16..
//

import XCTest

@testable import theMovieDataBase

final class NetworkControllerTests: XCTestCase {

	private lazy var bundle = Bundle(for: type(of: self))
	private var controller: NetworkController<PagedResource<Trending>>!

	override func setUp() {
		super.setUp()

		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [URLProtocolStub.self]
		let session = URLSession(configuration: configuration)
		let provider = TrendingURLProvider()
		controller = NetworkController(session: session, urlProvider: provider)
	}

	override func tearDown() {
		controller = nil

		super.tearDown()
	}

    func testSuccess() async throws {

		URLProtocolStub.setResponse(statusCode: 200, resource: "TrendingSuccess", extension: "json")

		let elements = try await controller.load()

		XCTAssertEqual(elements.page, 1)
		XCTAssertEqual(elements.totalPages, 1000)
		XCTAssertEqual(elements.totalResults, 20000)
		XCTAssertEqual(elements.results.count, 1)
    }

	func testInvalidAPIKeyFailure() async throws {
		let exp = expectation(description: "InvalidAPIKey catched successfully!")

		URLProtocolStub.setResponse(statusCode: 401, resource: "InvalidAPIKey", extension: "json")

		do {
			let _ = try await controller.load()
		} catch MDBError.dataTransferFailed(reason: .invalidAPIKey) {
			exp.fulfill()
		}

		await fulfillment(of: [exp])
	}
}
