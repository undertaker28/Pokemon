//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    @StateObject private var pokemonDetailViewModel: PokemonDetailViewModel
    
    init(url: String) {
        _pokemonDetailViewModel = StateObject(wrappedValue: PokemonDetailViewModel(url: url))
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemRed), Color.white]), startPoint: .top, endPoint: .bottom)
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
                            .font(.largeTitle)
                        
                        Text(pokemonDetailViewModel.detail?.types?[0].type?.name?.capitalized ?? "No type found")
                            .font(.subheadline).bold()
                            .foregroundColor(.white)
                            .padding(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                            .background(Color(.systemRed))
                            .cornerRadius(20)
                    }
                    .padding(.top, -40)
                    .zIndex(-1)
                    
                    HStack {
                        Text("Stats")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.leading, 30)
                        
                        Spacer()
                    }
                    
                    BarsView(height: pokemonDetailViewModel.detail?.height ?? 0, weight: pokemonDetailViewModel.detail?.weight ?? 0)
                        .padding(.trailing)
                        .padding(.top, -16)
                }
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(url: "https://pokeapi.co/api/v2/pokemon/25/")
    }
}
