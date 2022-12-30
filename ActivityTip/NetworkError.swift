//
//  NetworkError.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Foundation

enum NetworkError: Error {
    /// The API returns statucCode 200 for every response type, success or error,
    /// because of that, the error will be mapped always as a generic one.
    case genericError(description: String?)
    case decodeError(description: String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .genericError(description):
            return description
        case let .decodeError(description):
            return description
        }
    }
}
