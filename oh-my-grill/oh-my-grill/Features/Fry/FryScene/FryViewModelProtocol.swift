//
//  FryViewModelProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 08/12/25.
//

import Foundation

protocol FryViewModelProtocol {
    var session: GameSession { get }
    var round: Round? { get }
    var nextView: Bool { get set }
    var lastIngredientSliced: Ingredient? { get set }
}
