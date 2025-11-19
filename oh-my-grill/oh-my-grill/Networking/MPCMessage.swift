//
//  GameData.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 04/11/25.
//

import Foundation

// MultiPeer Connectivity Message - used to general data transfer between connected peers
public enum MPCMessage: Codable {
//    case gameConfig(GameConfigPayload)
//    case gameH(GamePayload)
//    case gameV(GamePayload)
    case notification(NotificationPayload)
}

// Used to send game data related to parcels
//public struct GamePayload: Codable {
//    public let x: CGFloat
//    public let y: CGFloat
//    public var side: EdgeSide = .none
//    public var ingredientType: IngredientType = .genericParcel
//    public var ingredientState: IngredientState = .base
//}

// Used to pass the initial game configs from the host to the players
//public struct GameConfigPayload: Codable {
//    let mode: GameMode
//    let players: [String]
//    let roles: [String: StationRole]
//}

// Used to trigger the notification delegates and make the app reactive
public struct NotificationPayload: Codable {
    public let notification: MPCNotifications
}
