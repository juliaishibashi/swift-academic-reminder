//
//  academic_reminderUITests.swift
//  academic-reminderUITests
//
//  Created by Julia on 2024-11-25.
//

import XCTest

final class academic_reminderUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].buttons["Assignments"].tap()

        let addButton = app.buttons["addAssignmentButton"]
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: addButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(addButton.exists, "The Add Assignment button does not exist.")
        addButton.tap()
        
        let titleTextField = app.textFields["Enter assignment title"]
        XCTAssertTrue(titleTextField.exists, "The title text field does not exist.")

        titleTextField.tap()
        titleTextField.typeText("Test Input")
        
        let courseTextField = app.textFields["Course"]
        XCTAssertTrue(courseTextField.exists)

        courseTextField.tap()
        courseTextField.typeText("CSC 999")
        
        let typeButton = app.images["arrowtriangleType"]
        XCTAssertTrue(typeButton.exists)
        typeButton.tap()
        
        let assignmentButton = app.buttons["Assignment"]
        XCTAssertTrue(assignmentButton.exists)
        assignmentButton.tap()
        
        let weightTextField = app.textFields["Enter Weight"]
        XCTAssertTrue(weightTextField.exists)
        
        weightTextField.tap()
        weightTextField.typeText("10")
        
//      reminder
        let reminderButton = app.buttons["plus.circle.fill"]
        XCTAssertTrue(reminderButton.exists)
        
        reminderButton.tap()
        
        let addReminder = app.buttons["addReminderButton"]
        XCTAssertTrue(addReminder.exists, "The Add Reminder button does not exist.")
        addReminder.tap()
        
        let addValue = app.textFields["Input integer"]
        XCTAssertTrue(addValue.exists)
        
        addValue.tap()
        addValue.typeText("10")
        
        let arrowButton = app.images["reminderArrowDownButton"]
        XCTAssertTrue(arrowButton.exists)
        arrowButton.tap()

        let minutesOption = app.buttons["Minutes"]
        XCTAssertTrue(minutesOption.exists, "The 'Minutes' option should be available")
        
        minutesOption.tap()
        
        let minutesButton = app.buttons["Minutes"]
        XCTAssertTrue(minutesButton.exists)
        
        let reminderSaveButton = app.buttons["reminderSave"]
        XCTAssertTrue(reminderSaveButton.exists)
        reminderSaveButton.tap()
        
        let saveAssignmentButton = app.buttons["assignmentSave"]
        XCTAssertTrue(saveAssignmentButton.exists)
        saveAssignmentButton.tap()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
