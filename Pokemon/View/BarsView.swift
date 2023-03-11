//
//  BarsView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarsView: View {
    private(set) var height: Int
    private(set) var weight: Int
    var body: some View {
        VStack {
            BarView(title: "Height", value: height, color: .orange)
            BarView(title: "Weight", value: weight, color: .purple)
        }
        .padding()
    }
}
