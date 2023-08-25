//
//  View+Ex.swift
//  Pokemon
//
//  Created by Pavel on 23.08.23.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomCornerShape(radius: radius, corners: corners))
    }
}
