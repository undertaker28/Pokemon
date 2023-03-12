//
//  BarsView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarsView: View {
    private(set) var barsViewModel = BarsViewModel()
    private(set) var height: Int
    private(set) var weight: Int
    
    var body: some View {
        VStack {
            BarView(value: barsViewModel.convertHeightToCm(height: height), title: "Height", color: .purple)
            BarView(value: barsViewModel.convertWeightToKg(weight: weight), title: "Weight", color: .blue)
        }
        .padding()
    }
}
