//
//  Stanford_CalculatorTests.swift
//  Stanford CalculatorTests
//
//  Created by Diogo M Souza on 2017/06/22.
//  Copyright © 2017 Diogo M Souza. All rights reserved.
//

import XCTest
@testable import Stanford_Calculator

class Stanford_CalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExampleOperand() {
        var testBrain = CalculatorBrain()
        testBrain.setOperand(5)
        XCTAssertEqual(testBrain.result, 5)
    }
    
    func testDescriptionTask6() {
        var testBrain = CalculatorBrain()
        
        // a. touching 7 + would show “7 + ...” (with 7 still in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        XCTAssertEqual(testBrain.description, "7 + ")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertFalse(testBrain.result != nil)
        
        //b. 7 + 9 would show “7 + …” (9 in the display)
        //same state as a in model
        
        //c. 7 + 9 = would show “7 + 9 =” (16 in the display)
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 16)
        
        //d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "√(7 + 9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 4)
        
        //e. 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
        testBrain.performOperation("+")
        testBrain.setOperand(2)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "√(7 + 9) + 2")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 6)
        
        //f. 7 + 9 √ would show “7 + √(9) …” (3 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 3)
        
        //g. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 10)
        
        //h. 7 + 9 = + 6 = + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9 + 6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 25)
        
        //i. 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("√")
        testBrain.setOperand(6)
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 9)
        
        //j. 5 + 6 = 7 3 would show “5 + 6 =” (73 in the display)
        testBrain.setOperand(5)
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        //testBrain.setOperand(73)   -> Not sent to model
        XCTAssertEqual(testBrain.description, "5 + 6")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 11)
        
        //k. 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
        testBrain.setOperand(4)
        testBrain.performOperation("×")
        testBrain.performOperation("π")
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "4 × π")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertTrue(abs(testBrain.result! - 12.5663706143592) < 0.0001)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
