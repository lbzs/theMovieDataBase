//
//  NetworkController.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

class NetworkController<T> where T: Decodable {

	private let session: URLSession
	private let urlProvider: URLProvider

	init(session: URLSession, urlProvider: URLProvider) {
		self.session = session
		self.urlProvider = urlProvider
	}

	func load() async throws -> T {
		guard let url = urlProvider.makeURL() else {
			throw MDBError.invalidURL
		}

		let urlRequest = URLRequest(url: url)

		// Request
		var (data, response): (Data, URLResponse)
		do {
			(data, response) = try await session.data(for: urlRequest)
		} catch {
			throw MDBError.dataTransferFailed(reason: .failed)
		}

		if let httpResponse = (response as? HTTPURLResponse),
		   !httpResponse.isSuccessful() {

			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			let decoded = try decoder.decode(ErrorResource.self, from: data)
			let failureReason = MDBError.DataTransferFailureReason.makeFailureReason(fromCode: decoded.statusCode, httpStatus: httpResponse.statusCode)
			throw MDBError.dataTransferFailed(reason: failureReason)
		}

		// Decode
		do {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			return try decoder.decode(T.self, from: data)
		} catch let error as DecodingError {
			throw MDBError.responseSerializationFailed(reason: .decodingFailure(error: error))
		}
	}
}
