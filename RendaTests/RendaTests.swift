//
//  RendaTests.swift
//  RendaTests
//
//  Created by Masaki Horimoto on 2015/07/30.
//  Copyright (c) 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit
import XCTest

class RendaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
        
    }
    
    func testEditCount1() {
        let testViewController: ViewController = ViewController()       //ViewControllerクラスをインスタンス化
        let result = testViewController.editCount(9999, digitNum: 4)    //テストしたいメソッドを呼び出し
        XCTAssertNotNil(result)                                         //テスト結果がnilでないか
        XCTAssertEqual(result, [9,9,9,9], "result is [9,9,9,9]")        //テスト結果(第1引数)が期待値(第2引数)と等しいか
    }
    
    func testEditCount2() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editCount(10001, digitNum: 4)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [0,0,0,1], "result is [0,0,0,1]")
    }
    
    func testEditCount3() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editCount(10001, digitNum: 10)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [0,0,0,0,0,1,0,0,0,1], "result is [0,0,0,0,0,1,0,0,0,1]")
    }
    
    func testEditCount4() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editCount(255, digitNum: 4)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [0,2,5,5], "result is [0,2,5,5]")
    }
    
    func testEditCount5() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editCount(0, digitNum: 4)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [0,0,0,0], "result is [0,0,0,0]")
    }
    
    func testEditCount6() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editCount(100, digitNum: 4)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [0,1,0,0], "result is [0,1,0,0]")
    }
    
    func testEditTimerCount1() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editTimerCount(0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 10, "result is 0")
    }

    func testEditTimerCount2() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editTimerCount(6)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 4, "result is 4")
    }

    func testEditTimerCount3() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editTimerCount(10)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 0, "result is 0")
    }
    
    func testEditTimerCount4() {
        let testViewController: ViewController = ViewController()
        let result = testViewController.editTimerCount(100)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 0, "result is 0")
    }
    
}
