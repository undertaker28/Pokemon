//
//  BarsViewModel.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation

final class BarsViewModel {
    func convertHeightToCm(height: Int) -> Double {
        return Double(height) * 10.0
    }
    
    func convertWeightToKg(weight: Int) -> Double {
        return Double(weight) / 10.0
    }
}
