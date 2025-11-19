//
//  NewGameViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import Foundation

@Observable
class NewGameViewModel: NewGameViewModelProtocol {
    var transport: (any TransportSessionProtocol)?
    var username: String = ""
}
