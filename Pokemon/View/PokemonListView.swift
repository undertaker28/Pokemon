//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct PokemonRow: View {
    private(set) var pokemonName: String
    
    var body: some View {
        HStack {
            Image("Pokeball")
            Text(pokemonName)
                .font(Font.custom("MarkPro-Bold", size: 18))
        }
    }
}

struct PokemonListView: View {
    @State private var searchText: String = ""
    @StateObject private var pokemonListViewModel = PokemonListViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        VStack {
            List((searchText.isEmpty ?  pokemonListViewModel.pokemonListPage?.results ?? [] : pokemonListViewModel.pokemonListPage?.results.filter({ $0.name.contains(searchText.lowercased()) })) ?? [], id: \.url) { pokemon in
                NavigationLink(destination: PokemonDetailView(url: pokemon.url)) {
                    PokemonRow(pokemonName: pokemon.name.capitalized)
                }
            }
            .searchable(text: $searchText, prompt: "Looking for something...")
            .environment(\.defaultMinListRowHeight, 50)
            HStack {
                Button {
                    pokemonListViewModel.dataService.getPage(url: pokemonListViewModel.pokemonListPage?.previous ?? "")
                } label: {
                    Text("Previous")
                        .font(Font.custom("WorkSans-Regular", size: 18))
                        .fixedSize()
                }
                .padding()
                .frame(maxWidth: .infinity)
                Divider()
                Button {
                    pokemonListViewModel.dataService.getPage(url: pokemonListViewModel.pokemonListPage?.next ?? "")
                } label: {
                    Text("Next")
                        .font(Font.custom("WorkSans-Regular", size: 18))
                        .fixedSize()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if networkMonitor.isConnected {
                            HStack(spacing: 10) {
                                Text("Wi-Fi on")
                                    .font(Font.custom("MarkPro-Bold", size: 18))
                                    .foregroundColor(.green)
                                Image(systemName: "wifi")
                            }
                        }
                        if networkMonitor.isCellular {
                            HStack(spacing: 10) {
                                Text("Cellular on")
                                    .font(Font.custom("MarkPro-Bold", size: 18))
                                    .foregroundColor(.yellow)
                                Image(systemName: "antenna.radiowaves.left.and.right")
                            }
                        }
                        if networkMonitor.isDisconnected {
                            HStack(spacing: 10) {
                                Text("No connection")
                                    .font(Font.custom("MarkPro-Bold", size: 18))
                                    .foregroundColor(.red)
                                Image(systemName: "wifi.slash")
                            }
                        }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
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
