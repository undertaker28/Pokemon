//
//  PokemonApp.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

@main
struct PokemonApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PokemonListView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Pokemons")
            }
        }
    }
}
