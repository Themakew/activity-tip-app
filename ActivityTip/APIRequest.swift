//
//  APIRequest.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Foundation
import Alamofire

enum BaseURL: String {
    case primary = "https://www.boredapi.com/api/"
}

struct APIRequest {

    // MARK: - Internal Properties

    let url: String
    let method: HTTPMethod
    let encodeType: ParameterEncoding

    // MARK: - Private Properties

    private let baseURL: BaseURL
    private let path: String

    // MARK: - Initializer

    init(
        method: HTTPMethod,
        baseURL: BaseURL = .primary,
        path: String,
        encodeType: ParameterEncoding = URLEncoding.default
    ) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.encodeType = encodeType
        self.url = baseURL.rawValue + path
    }

    // MARK: - Private Methods

    private func getURL(with baseURL: BaseURL, and path: String) -> String {
        return baseURL.rawValue + path
    }
}
