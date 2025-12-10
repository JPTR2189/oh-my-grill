//
//  oh_my_grillUITests.swift
//  oh-my-grillUITests
//
//  Created by Barbara da Silva Dapper on 18/11/25.
//

import XCTest

final class oh_my_grillUITests: XCTestCase {

    func testStartGameNavigation() {
        let app = XCUIApplication()
        app.launch()

        //given
        let startButton = app.buttons["startGameButton"]
        XCTAssertTrue(startButton.exists)

        //when
        startButton.tap()

        //then
        let newGameTitle = app.staticTexts["newGameTitle"]
        XCTAssertTrue(newGameTitle.waitForExistence(timeout: 2))
    }
    
    func testHostNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["startGameButton"].tap()

        //username
        let textField = app.textFields["USERNAME"]
        textField.tap()
        textField.typeText("Host")
        app.keyboards.buttons["Return"].tap()

        //given
        let hostButton = app.buttons["hostButton"]
        XCTAssertTrue(hostButton.waitForExistence(timeout: 2))
        
        //when
        hostButton.tap()

        //then
        let hostTitle = app.staticTexts["hostTitle"]
        XCTAssertTrue(hostTitle.waitForExistence(timeout: 3))
    }
    
    
    func testJoinNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["startGameButton"].tap()

        //username
        let field = app.textFields["USERNAME"]
        field.tap()
        field.typeText("Join")
        app.keyboards.buttons["Return"].tap()

        //given
        let joinButton = app.buttons["joinButton"]
        XCTAssertTrue(joinButton.waitForExistence(timeout: 3))
        
        //when
        joinButton.tap()

        //then
        let title = app.staticTexts["joinTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
    }
}
