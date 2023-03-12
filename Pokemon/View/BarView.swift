//
//  BarView.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import SwiftUI

struct BarView: View {
    @State private(set) var value: Double = 100.0
    private(set) var title: String = "Attack"
    private(set) var color: Color = .blue
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.custom("MarkPro-Bold", size: 18))
                .padding(.leading, 32)
                .foregroundColor(.gray)
                .frame(width: 100)
            
            HStack {
                Text(floor(value) == value ? "\(Int(value))" : String(format: "%.1f", value))
                    .font(Font.custom("MarkPro-Bold", size: 18))
                    .frame(width: 50)
                    .padding(.trailing)
                
                ProgressBarView(value: $value, color: color)
                    .frame(height: 20)
                
                Spacer()
            }
            .padding(.leading)
        }
    }
}

struct ProgressBarView: View {
    @Binding private(set) var value: Double
    private(set) var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(.systemGray3))
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value / 300) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
            }
            .cornerRadius(45)
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
