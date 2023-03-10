//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct PokemonRow: View {
    let pokemonName: String
    
    var body: some View {
        HStack {
            Image("Pokeball")
            Text(pokemonName)
        }
    }
}

struct PokemonListView: View {
    var body: some View {
        List {
            PokemonRow(pokemonName: "Bulbasaur")
            PokemonRow(pokemonName: "Ivysaur")
            PokemonRow(pokemonName: "Venusaur")
        }
        .environment(\.defaultMinListRowHeight, 50)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
