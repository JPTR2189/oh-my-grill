//
//  Transporting.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 11/11/25.
//

import Foundation
import MultipeerConnectivity

public protocol TransportSessionProtocol: AnyObject {
    var myPeerID: MCPeerID { get }
    var connectedPeers: [MCPeerID] { get }
    
    var passwordLength: Int { get }
    var playersNumber: Int { get }
    
    func startAdvertising(withPassword password: String?)
    func stopAdvertising()
    
    func startBrowsing()
    func stopBrowsing()
    
    func tryToJoin(withPassword password: String)
    func disconnect()
    
    func send(_ message: MPCMessage)
    func send(_ data: Data, reliably: Bool) throws
    func sendNotification(_ notification: MPCNotifications)
    
    var onReceiveData: ((Data, MCPeerID) -> Void)? { get set }
    var onPeerChange: (([MCPeerID]) -> Void)? { get set }
    
    func setNotificationHandler(_ handler: MPCNotificationDelegate)
    func notifyDelegate(_ notification: MPCNotifications)
}
