//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var pokemonDetailViewModel: PokemonDetailViewModel
    
    init(url: String) {
        _pokemonDetailViewModel = StateObject(wrappedValue: PokemonDetailViewModel(url: url))
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(pokemonDetailViewModel.backgroundColor(forType: pokemonDetailViewModel.detail?.types?[0].type?.name ?? "No name found")), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Color.white.offset(y: 340)
            
            VStack {
                if pokemonDetailViewModel.isLoadingImage {
                    ProgressView()
                } else {
                    Image(uiImage: (pokemonDetailViewModel.image ?? UIImage(systemName: "questionmark.circle"))!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                
                if pokemonDetailViewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        Text(pokemonDetailViewModel.detail?.name?.capitalized ?? "No name found")
                            .font(Font.custom("MarkPro-Bold", size: 32))
                        
                        Text(pokemonDetailViewModel.detail?.types?[0].type?.name?.capitalized ?? "No type found")
                            .font(Font.custom("MarkPro-Bold", size: 24))
                            .foregroundColor(.white)
                            .padding(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                            .background(Color(pokemonDetailViewModel.backgroundColor(forType: pokemonDetailViewModel.detail?.types?[0].type?.name ?? "No name found")))
                            .cornerRadius(20)
                    }
                    .padding(.top, -40)
                    .zIndex(-1)
                    
                    HStack {
                        Text("Stats")
                            .font(Font.custom("MarkPro-Bold", size: 20))
                            .padding(.leading, 30)
                        
                        Spacer()
                    }
                    
                    BarsView(height: pokemonDetailViewModel.detail?.height ?? 0, weight: pokemonDetailViewModel.detail?.weight ?? 0)
                }
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(url: "https://pokeapi.co/api/v2/pokemon/13/")
    }
}
