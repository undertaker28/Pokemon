//
//  BarsView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarsView: View {
    private(set) var barsViewModel: BarsViewModel
    private(set) var height: Int
    private(set) var weight: Int
    
    init(barsViewModel: BarsViewModel, height: Int, weight: Int) {
        self.barsViewModel = barsViewModel
        self.height = height
        self.weight = weight
    }
    
    var body: some View {
        VStack {
            BarView(value: barsViewModel.convertHeightToCm(height: height), title: Constants.height, color: .purple)
            BarView(value: barsViewModel.convertWeightToKg(weight: weight), title: Constants.weight, color: .blue)
        }
        .padding()
    }
}
