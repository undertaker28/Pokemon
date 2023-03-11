//
//  BarView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarView: View {
    var title: String = "Attack"
    var value: Int = 100
    var color: Color = .blue

    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 32)
                .foregroundColor(.gray)
                .frame(width: 100)

            HStack {
                Text("\(value)")
                    .frame(width: 45)
                    .padding(.trailing)

                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: 180, height: 20)
                        .foregroundColor(Color(.systemGray5))

                    Capsule()
                        .frame(width: value > 180 ? CGFloat(value / 6) : CGFloat(value), height: 20)
                        .foregroundColor(color)
                }
                Spacer()
            }
            .padding(.leading)
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
