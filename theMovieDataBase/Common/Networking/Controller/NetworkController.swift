//
//  NetworkController.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

class NetworkController<T> where T: Decodable {

	enum NetworkError: Error {
		case failedToCreateURL
		case failedToDecode
		case apiError
	}

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

		do {
			// Request
			let (data, response) = try await session.data(for: urlRequest)
			if let httpStatus = (response as? HTTPURLResponse)?.statusCode,
			   !httpStatus.isStatusSuccessful() {

				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let decoded = try decoder.decode(ErrorResource.self, from: data)
				let failureReason = MDBError.DataTransferFailureReason.makeFailureReason(fromCode: decoded.statusCode, httpStatus: httpStatus)
				throw MDBError.dataTransferFailed(reason: failureReason)
			}

			// Decode
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			let decoded = try decoder.decode(T.self, from: data)
			return decoded

		} catch let error as DecodingError {
			throw MDBError.responseSerializationFailed(reason: .decodingFailure(error: error))
		} catch {
			throw MDBError.dataTransferFailed(reason: .failed)
		}
	}
}

fileprivate extension Int {

	func isStatusSuccessful() -> Bool {
		switch self {
		case 200, 201:
			return true
		default:
			return false
		}
	}
}
