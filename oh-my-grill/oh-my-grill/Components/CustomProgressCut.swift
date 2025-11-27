//
//  CustomProgressCut.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//
import SwiftUI

struct CustomProgressCut: ProgressViewStyle {
    var height: CGFloat = 29
    var cornerRadius: CGFloat = 6
    var progressColor: Color = .texasGreen
    var trackColor: Color = .texasBeige
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(trackColor)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(progressColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .frame(height: height)
    }
}
