//
//  JoinViewModelTests.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 10/12/25.
//


import XCTest
@testable import oh_my_grill
import Foundation
import MultipeerConnectivity 

class JoinViewModelTests: XCTestCase {

    var mockTransport: TransportSessionProtocol!
    var viewModel: JoinViewModel!
    
    private func initializeViewModel(with transport: TransportSessionProtocol) {
        self.viewModel = JoinViewModel(transport:  transport)
    }

    override func setUp() {
        super.setUp()
        
        let transport = MockTransportSession()
        self.mockTransport = transport
        self.initializeViewModel(with: transport)
    }
    
    override func tearDown() {
        viewModel = nil
        mockTransport = nil
        super.tearDown()
    }
    
    func testPasswordLimit() {
        let expectedLength = mockTransport.passwordLength
        
        for i in 1...5 {
            viewModel.insertToPassword(String(i))
        }
        
        XCTAssertEqual(viewModel.password.count, expectedLength)
        XCTAssertEqual(viewModel.rawPassword, "1234")
    }
    
    func testWrongPasswordFlagResetOnInput() {
        viewModel.wrongPassword = true
        viewModel.insertToPassword("5")
        XCTAssertFalse(viewModel.wrongPassword, "Inserir um caractere deve resetar a flag.")
    }

    func testTryToJoin_ResetsWrongPasswordFlagAndCallsTransport() {
        viewModel.wrongPassword = true
        let mockPassword = "ABCD"
        
        for char in mockPassword {
            viewModel.insertToPassword(String(char))
        }
        
        viewModel.tryToJoin(withPassword: viewModel.rawPassword)
        
        XCTAssertFalse(viewModel.wrongPassword, "O tryToJoin deve resetar o flag 'wrongPassword'.")
    }
}
