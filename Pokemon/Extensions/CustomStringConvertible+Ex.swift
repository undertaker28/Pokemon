//
//  CustomStringConvertible+Ex.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

extension NetworkingErrors: CustomStringConvertible {
    var description: String {
        switch self {
        case .badURLResponse(url: let url):
            return "Bad response from URL: \(url)"
        case .unknow:
            return "Unknow error occured"
        }
    }
}
