//
//  LoadingView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 21/11/25.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        ZStack(alignment: .center) {
            //MARK: Fundo
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            //MARK: Conteúdo
            Image(.star)
                .resizable()
                .scaledToFit()
                .frame(width: 118, height: 136)
                .padding(.bottom, 65)
        }
    }
}
#Preview {
    LoadingView()
}
