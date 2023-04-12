//
//  PokemonList.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

// URL 1st page: https://pokeapi.co/api/v2/pokemon
// URL 2nd page: https://pokeapi.co/api/v2/pokemon?offset=20&limit=20

struct PokemonList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonInfo]
}

struct PokemonInfo: Codable {
    let name: String
    let url: String
}

struct PokemonMappingInfo: Codable {
    let id: Int
    let name: String
}
