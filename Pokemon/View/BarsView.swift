//
//  BarsView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarsView: View {
    let pokemon: PokemonDetail
    var body: some View {
        VStack {
            BarView(title: "Height", value: pokemon.height ?? 0, color: .orange)
            BarView(title: "Weight", value: pokemon.weight ?? 0, color: .purple)
        }
        .padding()
    }
}
