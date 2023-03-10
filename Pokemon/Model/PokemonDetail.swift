//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

// URL: https://pokeapi.co/api/v2/pokemon/{id}/

struct PokemonDetail: Codable {
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [TypeElement]?
    let sprites: Sprites?
}

struct TypeElement: Codable {
    let slot: Int?
    let type: Species?
}

struct Species: Codable {
    let name: String?
    let url: String?
}

struct Sprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
