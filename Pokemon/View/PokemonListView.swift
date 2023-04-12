//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var pokemonListViewModel = PokemonListViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            List((searchText.isEmpty ? pokemonListViewModel.getPokemons() : pokemonListViewModel.getPokemons().filter({ $0.name.contains(searchText.lowercased()) })), id: \.id) { pokemon in
                NavigationLink(destination: PokemonDetailView(url: Endpoint.pokemon(pokemon.id).url)) {
                      HStack {
                          Image(Constants.pokeballImage)
                          Text(pokemon.name.capitalized)
                              .font(Font.custom(Constants.fontMarkProBold, size: 18))
                      }
                  }
              }
            .overlay(
                VStack {
                    if pokemonListViewModel.getPokemons()
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
            
            HStack {
                Button {
                    if let previousUrlString = pokemonListViewModel.pokemonListPage?.previous,
                       let previousUrl = URL(string: previousUrlString) {
                        pokemonListViewModel.dataHelper.getPage(url: previousUrl)
                    }
                } label: {
                    Text(Constants.previous)
                        .font(Font.custom(Constants.fontWorkSansRegular, size: 18))
                        .fixedSize()
                }
                .padding()
                .frame(maxWidth: .infinity)
                Divider()
                Button {
                    if let nextUrlString = pokemonListViewModel.pokemonListPage?.next,
                       let nextUrl = URL(string: nextUrlString) {
                        pokemonListViewModel.dataHelper.getPage(url: nextUrl)
                    }
                } label: {
                    Text(Constants.next)
                        .font(Font.custom(Constants.fontWorkSansRegular, size: 18))
                        .fixedSize()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color(Constants.textTabBar))
            .background(Color(Constants.background))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if networkMonitor.isConnected {
                        pokemonListViewModel.toolbarItem(Constants.wifiOn, Constants.wifiImage, .green)
                    }
                    if networkMonitor.isCellular {
                        pokemonListViewModel.toolbarItem(Constants.cellularOn, Constants.cellularImage, .yellow)
                    }
                    if networkMonitor.isDisconnected {
                        pokemonListViewModel.toolbarItem(Constants.noConnection, Constants.noConnectionImage, .red)
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
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
