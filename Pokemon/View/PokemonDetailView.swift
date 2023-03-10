//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemRed), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Color.white.offset(y: 370)
            
            VStack {
                KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2F2CF15848-AAF9-49C0-90E4-28DC78F60A78?alt=media&token=15ecd49b-89ff-46d6-be0f-1812c948e334"))
                    .resizable()
                    .frame(width: 200, height: 200)
                
                VStack {
                    Text("Bulbasaur")
                        .font(.largeTitle)
                        .padding(.top, 40)
                    
                    Text("Poison")
                        .font(.subheadline).bold()
                        .foregroundColor(.white)
                        .padding(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                        .background(Color(.systemRed))
                        .cornerRadius(20)
                }
                .background(Color.white)
                .cornerRadius(40)
                .padding(.top, -40)
                .zIndex(-1)
                
                HStack {
                    Text("Stats")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.leading)
                    
                    Spacer()
                }
                
//                BarsView(pokemon: pokemon)
//                    .padding(.trailing)
//                    .padding(.top, -16)
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView()
    }
}
