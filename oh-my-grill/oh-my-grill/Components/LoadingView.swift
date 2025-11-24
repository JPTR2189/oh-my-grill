//
//  LoadingView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 21/11/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                TimelineView(.animation) { context in
                    let angle = context.date.timeIntervalSinceReferenceDate * 200

                    Image(.star)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 118, height: 136)
                        .rotationEffect(.degrees(angle))
                }
                .padding(.bottom, 120)
            }
        }

    }
}


#Preview {
    LoadingView()
}

