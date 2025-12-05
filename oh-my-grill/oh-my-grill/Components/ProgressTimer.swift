//
//  ProgressTimer.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 05/12/25.
//

import SwiftUI

struct ProgressTimer: View {
    @State private var progress: CGFloat = 0
    let duration: TimeInterval
    let lineWidth: CGFloat
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth))
                .foregroundColor(Color.white.opacity(0.25))

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progress < 1 ? Color.yellow : Color.green,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: duration), value: progress)
        }
        .onAppear {
            start()
        }
    }

    private func start() {
        progress = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            onFinished()
        }
    }
}
