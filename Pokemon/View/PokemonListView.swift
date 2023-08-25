//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI
import Alamofire

struct PokemonListView: View {
    @StateObject private var pokemonListViewModel = PokemonListViewModel()
    @StateObject private var networkMonitor = NetworkMonitor(reachabilityManager: NetworkReachabilityManager())
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            List(pokemonListViewModel.getFilteredPokemons(searchText: searchText), id: \.id) { pokemon in
                NavigationLink(destination: PokemonDetailView(url: Endpoint.pokemon(pokemon.id).url)) {
                      HStack {
                          Image(Constants.pokeballImage)
                          Text(pokemon.name.capitalized)
                              .font(Font.custom(Constants.fontMarkProBold, size: 18))
                      }
                  }
                .onAppear {
                    pokemonListViewModel.loadMoreContentIfNeeded(currentItem: pokemon)
                  }
              }
            .overlay(
                VStack {
                    if pokemonListViewModel.pokemons
                        .filter({ $0.name.contains(searchText.lowercased()) })
                        .isEmpty && !searchText.isEmpty {
                        Text(Constants.firstPartOfEmptySearchMessage)
                        + Text(searchText)
                            .fontWeight(.heavy)
                        + Text(Constants.secondPartOfEmptySearchMessage)
                    }
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            )
            .environment(\.defaultMinListRowHeight, 50)
            .searchable(text: $searchText, prompt: Constants.placeholder)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if networkMonitor.isConnected {
                        ToolbarItemView(Constants.wifiOn, Constants.wifiImage, .green)
                    }
                    if networkMonitor.isCellular {
                        ToolbarItemView(Constants.cellularOn, Constants.cellularImage, .yellow)
                    }
                    if networkMonitor.isDisconnected {
                        ToolbarItemView(Constants.noConnection, Constants.noConnectionImage, .red)
                    }
                }
            }
        }
        .onAppear {
            networkMonitor.startMonitoring()
        }
        .onDisappear {
            networkMonitor.stopMonitoring()
        }
    }
    
    @ViewBuilder
    private func ToolbarItemView(_ text: String, _ imageName: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            Text(text)
                .font(Font.custom(Constants.fontMarkProBold, size: 18))
                .foregroundColor(color)
            Image(systemName: imageName)
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
