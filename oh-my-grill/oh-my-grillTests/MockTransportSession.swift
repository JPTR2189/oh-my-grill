//
//  MPCMessage.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 10/12/25.
//
import XCTest
import Foundation
import MultipeerConnectivity
@testable import oh_my_grill

class MockTransportSession: TransportSessionProtocol {
    var tryToJoinCalled = false
    var capturedPassword: String?
    
    var myPeerID: MCPeerID = MCPeerID(displayName: "MockPeer")
    var connectedPeers: [MCPeerID] = []
    var passwordLength: Int = 4
    var playersNumber: Int = 2
    
    var onReceiveData: ((Data, MCPeerID) -> Void)?
    var onPeerChange: (([MCPeerID]) -> Void)?
    
    func startAdvertising(withPassword password: String?) { /* Mock */ }
    func stopAdvertising() { /* Mock */ }
    func startBrowsing() { /* Mock */ }
    func stopBrowsing() { /* Mock */ }
    
    func tryToJoin(withPassword password: String) {
        tryToJoinCalled = true
        capturedPassword = password
    }
    
    func disconnect() { /* Mock */ }
    func send(_ message: MPCMessage) { /* Mock */ }
    func send(_ data: Data, reliably: Bool) throws { /* Mock */ }
    func sendNotification(_ notification: MPCNotifications) { /* Mock */ }
    func setNotificationHandler(_ handler: MPCNotificationDelegate) { /* Mock */ }
    func notifyDelegate(_ notification: MPCNotifications) { /* Mock */ }
}
