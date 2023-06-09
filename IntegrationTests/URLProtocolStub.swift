//
//  URLProtocolStub.swift
//  IntegrationTests
//
//  Created by Bálna on 2023. 05. 16..
//

import Foundation

final class URLProtocolStub: URLProtocol {

	static var requestHandler: ((URLRequest) throws -> Result<(Data, HTTPURLResponse), Error>)?

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		guard let handler = URLProtocolStub.requestHandler else {
			return
		}

		do {
			let result = try handler(request)
			switch result {
			case .success((let data, let response)):
				client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
				client?.urlProtocol(self, didLoad: data)
				client?.urlProtocolDidFinishLoading(self)
			case .failure(let error):
				client?.urlProtocol(self, didFailWithError: error)
			}
		} catch {
			client?.urlProtocol(self, didFailWithError: error)
		}
	}

	override func stopLoading() {}
}

extension URLProtocolStub {

	static func setResponse(statusCode: Int, resource: String, extension: String) {
		URLProtocolStub.requestHandler = { request in
			return URLProtocolStub.response(url: request.url!, for: resource, with: `extension`, statusCode: statusCode)
		}
	}

	static func response(url: URL, for resource: String, with extension: String, statusCode: Int) -> (Result<(Data, HTTPURLResponse), Error>) {
		let bundle = Bundle(for: Self.self)
		let path = bundle.url(forResource: resource, withExtension: `extension`)
		let data = try! Data(contentsOf: path!)
		let response = HTTPURLResponse.init(url: url,
											statusCode: statusCode,
											httpVersion: "2.0",
											headerFields: nil)!
		return .success((data, response))
	}
}
