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

	private var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()

	init(session: URLSession, urlProvider: URLProvider) {
		self.session = session
		self.urlProvider = urlProvider
	}

	func load() async throws -> T {
		guard let url = urlProvider.makeURL() else {
			throw MDBError.invalidURL
		}

		let data = try await loadData(from: url)

		// Decode
		do {
			return try decoder.decode(T.self, from: data)
		} catch let error as DecodingError {
			throw MDBError.responseSerializationFailed(reason: .decodingFailure(error: error))
		}
	}

	func loadData(from url: URL) async throws -> Data {
		var urlRequest = URLRequest(url: url)
		urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(Constants.APIReadAccessToken)"]

		// Request
		var (data, response): (Data, URLResponse)
		do {
			(data, response) = try await session.data(for: urlRequest)
		} catch {
			throw MDBError.dataTransferFailed(reason: .failed)
		}

		// API error decode
		if let httpResponse = (response as? HTTPURLResponse),
		   !httpResponse.isSuccessful() {

			let decoded = try decoder.decode(ErrorResource.self, from: data)
			let failureReason = MDBError.DataTransferFailureReason.makeFailureReason(fromCode: decoded.statusCode, httpStatus: httpResponse.statusCode)
			throw MDBError.dataTransferFailed(reason: failureReason)
		}

		return data
	}

	/// Loads the data of images
	///
	/// - Parameter imagePaths: Specifies the path from where the image can be downloaded
	/// - Returns: A dictionary where the key is the `imagePath` and the key is the data assosiated with it
	func loadImageData(from imagePaths: [String]) async throws -> [String: Data] {

		try await withThrowingTaskGroup(of: (String, Data).self) { group in
			for path in imagePaths {
				guard let url = URL(string: "https://image.tmdb.org/t/p/w300\(path)") else {
					break
				}
				group.addTask {
					let data = try await self.loadData(from: url)
					return (path, data)
				}
			}

			let result = try await group.reduce(into: [:], { partialResult, nextResult in
				partialResult[nextResult.0] = nextResult.1
			})

			return result
		}
	}
}
