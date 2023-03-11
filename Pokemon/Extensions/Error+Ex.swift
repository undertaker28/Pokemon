//
//  Error+Ex.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation

extension NetworkingErrors {
    init(code: Int, url: URL) {
        switch code {
        case 400:
            self = .badRequest(url: url)
        case 401:
            self = .unauthorized(url: url)
        case 404:
            self = .notFound(url: url)
        case 422:
            self = .unprocessableRequest(url: url)
        case 500:
            self = .serverError(url: url)
        default:
            self = .unknown(url: url)
        }
    }
}
