//
//  MDBError.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

enum MDBError: Error {

	enum ResponseSerializationFailureReason {
		case decodingFailure(error: Error)
	}

	enum DataTransferFailureReason {
		case authenticationFailed
		case invalidAPIKey
		case failed
	}

	case invalidURL
	case dataTransferFailed(reason: DataTransferFailureReason)
	case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

extension MDBError.DataTransferFailureReason {

	static func makeFailureReason(fromCode code: Int, httpStatus status: Int) -> MDBError.DataTransferFailureReason {
		switch(code, status) {
		case (3, 401):
			return .authenticationFailed
		case (7, 401):
			return .invalidAPIKey
		default:
			return .failed
		}
	}
}
