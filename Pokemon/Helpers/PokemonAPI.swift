//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Pavel on 11.04.23.
//

import Foundation
import Combine

enum Endpoint {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
    
    case pokemons
    case pokemon(Int)
    
    var url: URL {
        switch self {
        case .pokemons:
            return Endpoint.baseURL.appendingPathComponent("pokemon")
        case .pokemon(let id):
            return Endpoint.baseURL.appendingPathComponent("pokemon/\(id)/")
        }
    }
}
