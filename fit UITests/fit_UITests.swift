//
//  fit_UITests.swift
//  fit UITests
//
//  Created by Alberto Lunardini on 22/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import XCTest

class fit_UITests: XCTestCase {
    let timeToWait:Double = 0.0
    
    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch() 
        Snapshot.setLanguage(app)
        sShotGirths(app: app)
        sShotPlicheAndGraph(app: app)
        sShotCameraOptn(app: app)
        sShotInsight(app: app)
        sShotPhotoGallery(app: app)
        sShotInsightBicepGirths(app: app)
        sShotInsightBodyDensityGraph(app: app)
        sShotsupplementSearch(app: app)
        sShotSettings(app: app)
    }
    
    func sShotGirths(app : XCUIApplication){
        let tapWeight = app.collectionViews.cells.element(boundBy: 0)
        tapWeight.tap()
        snapshot("001_GirthsBicep")
        WaitTo(app: app, time: timeToWait)
        let inputWeight = app.textFields["girthsWeight"]
        inputWeight.tap()
        inputWeight.typeText("77")
        app.buttons["girthOK"].tap()
    }
    
    func sShotPlicheAndGraph(app : XCUIApplication) {
        let scrollView = app.scrollViews.element(boundBy: 1)
        scrollView.swipeLeft()
        scrollView.menuItems.element(boundBy: 1)
        selectCell(app: app, cell: 0)
        snapshot("003_PlicheGraph")
        WaitTo(app: app, time: timeToWait)
        app.buttons["graphOK"].tap()
    }
    
    func sShotCameraOptn(app : XCUIApplication) {
        changeTabBarItem(app: app, item: 1)
        snapshot("004_CameraOption")
    }
    
    func sShotInsight(app : XCUIApplication) {
        changeTabBarItem(app: app, item: 2)
    }
    
    func sShotPhotoGallery(app : XCUIApplication) {
        let scrollView = app.scrollViews.element(boundBy: 1)
        scrollView.swipeLeft()
        scrollView.menuItems.element(boundBy: 1)
        WaitTo(app: app, time: timeToWait)
        snapshot("011_PhotoGallery")
        WaitTo(app: app, time: timeToWait)
        scrollView.swipeRight()
        scrollView.menuItems.element(boundBy: 0)
        
        snapshot("005_InsightController")
    }
    
    func sShotInsightBicepGirths(app : XCUIApplication) {
        let GirthsTable = app.tables.element(boundBy: 0)
        let bicepGirths = GirthsTable.cells.element(boundBy: 2)
        bicepGirths.tap()
        snapshot("006_BicepGirths")
        WaitTo(app: app, time: timeToWait)
        app.buttons["overlayBtn"].tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("007_BicepGirths+OverlayWeight")
        WaitTo(app: app, time: timeToWait)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        WaitTo(app: app, time: timeToWait)
    }
    
    func sShotInsightBodyDensityGraph(app : XCUIApplication) {
        let GirthsTable = app.tables.element(boundBy: 0)
        GirthsTable.swipeUp()
        GirthsTable.swipeUp()
        let bodyDensity = GirthsTable.cells.element(boundBy: 17)
        bodyDensity.tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("008_bodyDensityGraph")
        app.buttons["overlayBtn"].tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("009_bodyDensityGraph+OverlayWeight")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let leanMass = GirthsTable.cells.element(boundBy: 19)
        leanMass.tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("009_LeanMassGraph")
        app.buttons["overlayBtn"].tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("010_LeanMassGraph+OverlayWeight")
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func sShotsupplementSearch(app : XCUIApplication) {
        changeTabBarItem(app: app, item: 3)
        snapshot("012_SupplementList")
        WaitTo(app: app, time: timeToWait)
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("whey gluten")
        app.keyboards.buttons["Search"].tap()
        WaitTo(app: app, time: timeToWait)
        let tapWeight = app.tables.cells.element(boundBy: 1)
        tapWeight.tap()
        snapshot("013_SupplementSearched")
        WaitTo(app: app, time: timeToWait)
        let inputQty = app.textFields["pq"]
        inputQty.tap()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "kg")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "1.0")
        let inputDay = app.textFields["dq"]
        inputDay.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "20")
        let inputWeek = app.textFields["wq"]
        inputWeek.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "6 Days")
        app.buttons["DoneKeyboard"].tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("014_SupplementDetails")
        app.switches.element(boundBy: 0).tap()
        WaitTo(app: app, time: timeToWait)
        snapshot("015_SupplementWithAllertReminder")
    }
    func sShotSettings (app : XCUIApplication){
        changeTabBarItem(app: app, item: 4)
        snapshot("016_Settings")
    }
    
}
extension fit_UITests {
    func hitTextField(app : XCUIApplication,identifier : String, lower : Int, upper : Int){
        let randomInt = Int.random(in: lower ..< upper)
        let input1 = app.textFields[identifier]
        input1.tap()
        input1.typeText(String(randomInt))
    }
    
    func selectCell(app : XCUIApplication, cell : Int ){
        let firstCell = app.collectionViews.cells.element(boundBy: cell)
        firstCell.tap()
        hitTextField(app: app, identifier: "skinFold1", lower: 3, upper: 12)
        hitTextField(app: app, identifier: "skinFold2", lower: 0, upper: 10)
        hitTextField(app: app, identifier: "skinFold3", lower: 5, upper: 9)
        snapshot("002_Pliche3measures")
        app.buttons["skinFoldOK"].tap()
    }
    func changeTabBarItem(app : XCUIApplication, item : Int) {
        app.tabBars.firstMatch.buttons.element(boundBy: item).tap()
        
    }
    func swipePage(app : XCUIApplication, item : Int) {
        let scrollView = app.scrollViews.element(boundBy: item)
        scrollView.swipeLeft()
        scrollView.menuItems.element(boundBy: item)
    }
    @discardableResult func WaitTo(app : XCUIApplication, time:Double) -> Bool{
        return app.wait(for: .unknown, timeout: time)
    }
}
