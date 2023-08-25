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
    
    init(url: URL) {
        _pokemonDetailViewModel = StateObject(wrappedValue: PokemonDetailViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(pokemonDetailViewModel.backgroundColor(forType: pokemonDetailViewModel.detail?.types?[0].type?.name ?? Constants.noNameFound)), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Color(Constants.background)
                .cornerRadius(15, corners: [.topLeft, .topRight])
                .padding(.top, 340)
                .ignoresSafeArea()
            
            VStack {
                KFImage(URL(string: pokemonDetailViewModel.detail?.sprites?.frontDefault ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                
                if pokemonDetailViewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        Text(pokemonDetailViewModel.detail?.name?.capitalized ?? Constants.noNameFound)
                            .font(Font.custom(Constants.fontMarkProBold, size: 32))
                        
                        Text(pokemonDetailViewModel.detail?.types?[0].type?.name?.capitalized ?? Constants.noTypeFound)
                            .font(Font.custom(Constants.fontMarkProBold, size: 24))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                            .background(Color(pokemonDetailViewModel.backgroundColor(forType: pokemonDetailViewModel.detail?.types?[0].type?.name ?? Constants.noNameFound)))
                            .cornerRadius(20)
                    }
                    .zIndex(-1)
                    
                    HStack {
                        Text(Constants.stats)
                            .font(Font.custom(Constants.fontMarkProBold, size: 20))
                            .padding(.leading, 30)
                        
                        Spacer()
                    }
                    
                    BarsView(barsViewModel: BarsViewModel(), height: pokemonDetailViewModel.detail?.height ?? 0, weight: pokemonDetailViewModel.detail?.weight ?? 0)
                }
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(url: Endpoint.pokemon(15).url)
    }
}
