//
//  GameSession.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 14/11/25.
//

import Foundation
import MultipeerConnectivity
import Combine



// Incapsulates the player name - used to transport IDs instead of MCPeerID instances
public struct PlayerID: Hashable, Codable {
    let rawValue: String
}


@Observable
public final class GameSession {
    
    // Transport layer
    private let transport: any TransportSessionProtocol
    
    // Current game mode
    private let gameMode: GameMode
    
    // Connected players and their roles
    private let players: [PlayerID]
    private(set) var roles: [PlayerID: StationRole]
    
    
    public var myID: PlayerID {
        PlayerID(rawValue: transport.myPeerID.displayName)
    }
    
    public var myRole: StationRole {
        roles[myID] ?? .notSet
    }
    
    private var chefID: PlayerID? {
        roles.first(where: { $0.value == .chef })?.key
    }
    
    private var amIChef: Bool {
        chefID == myID
    }
    
    //round
    private(set) var currentRound: Round?
    private var roundNumber: Int = 1
    public var finishedRound: Round?
    
    //orders
    private(set) var currentOrders: [Order] = []
    private var orderTimer: Timer?
    private let generator = OrderGenerator()
    
    
    // Initializer
    public init(transport: any TransportSessionProtocol, config: GameConfigPayload) {
        self.transport = transport
        self.gameMode = config.mode
        self.players = config.players.map { PlayerID(rawValue: $0) }
        self.roles = config.roles.reduce(into: [PlayerID: StationRole]()) { dict, pair in
            dict[PlayerID(rawValue: pair.key)] = pair.value
        }
        
        startNewRound()
        updateOrders()
    }
    
    // Sends a Ingredient to the chef - used on classic mode
    public func sendIngredientToChef(_ ingredient: Ingredient) {
        let x: CGFloat = CGFloat.random(in: -200...200)
        let y: CGFloat = -200
        
        let payload = GamePayload(x: x, y: y, ingredientType: ingredient.type, ingredientState: ingredient.state)
        
        let message = MPCMessage.gameV(payload)
        transport.send(message)
    }
    
    // Used to get the 'neighboor' - on classic mode, always returns the chefID
    public func destinationForToss(from side: EdgeSide) -> PlayerID? {
        switch gameMode {
        case .classic:
            return chefID
            
        case .chaos:
            // TODO: topography
            return chefID
        }
    }
    
    // Initialize a new round
    public func startNewRound() {
        let minRequiredPoints = 150
        
        let newRound = Round(
            number: roundNumber,
            minPoints: minRequiredPoints
        )
        
        newRound.onFinished = { [weak self] round in
                self?.roundDidFinish(round)
            }
        
        currentRound = newRound
        roundNumber += 1
        
        startOrderLoop()
    }
    
    @MainActor
    private func roundDidFinish(_ round: Round) {
        finishedRound = round

        orderTimer?.invalidate()
        currentOrders.removeAll()
    }

    
    public func finishRound() {
        guard let round = currentRound else { return }
        round.invalidateTimer()
        round.getFeedback()
        orderTimer?.invalidate()
        currentOrders.removeAll()
    }
    
    // Initialize Orders
    private func startOrderLoop() {
        orderTimer?.invalidate()
        
        orderTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateOrders()
        }
    }
    
    private func updateOrders() {
        currentOrders.removeAll { $0.status == .expired || $0.status == .delivered }
        
        if currentOrders.isEmpty {
            var newOrder = Order(meal: generator.generateOrder().meal)
            newOrder.onStatusChanged = { [weak self] updatedOrder in
                self?.orderStatusDidChange(updatedOrder)
            }
            currentOrders.append(newOrder)
        }
    }

    @MainActor
    private func orderStatusDidChange(_ order: Order) {
        if order.status == .expired || order.status == .delivered {
            replaceOrder(order)
        }
    }

    @MainActor
    private func replaceOrder(_ order: Order) {
        currentOrders.removeAll { $0.id == order.id }

        var newOrder = Order(meal: generator.generateOrder().meal)
        newOrder.onStatusChanged = { [weak self] updated in
            self?.orderStatusDidChange(updated)
        }

        currentOrders.append(newOrder)
    }

    
}


// MARK: - Transmission layer masking
extension GameSession {
    
    // Exposes notification delegate from the transport layer
    public func setNotificationHandler(_ handler: MPCNotificationDelegate) {
        transport.setNotificationHandler(handler)
    }
    
    // Exposes specific use of the send(message) function
    public func sendParcelHorizontally(_ payload: GamePayload) {
        let message = MPCMessage.gameH(payload)
        transport.send(message)
    }
    
//    public func sendNotification(_ notification: MPCNotifications) {
//        transport.sendNotification(notification)
//    }
}
