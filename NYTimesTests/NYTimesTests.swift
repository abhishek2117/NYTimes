//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Champ on 18/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import XCTest
@testable import NYTimes


class NYTimesTests: XCTestCase {

    var vc: ViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tempVC: ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc = tempVC
        _ = vc.view // To call viewDidLoad
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - View loading tests
    func viewLoadTest() {
        XCTAssertNotNil(vc.view, "View not initiated properly")
    }
    
    func testParentViewHasTableViewSubview() {
        let subviews = vc.view.subviews
        XCTAssertTrue(subviews.contains(vc.tblArticle), "View does not have a table subview")
    }
    
    func testThatTableViewLoads() {
        XCTAssertNotNil(vc.tblArticle, "TableView not initiated")
    }
    
    // MARK: - UITableView tests
    func testForUITableViewDataSource() {
        
        XCTAssertTrue(vc != nil, "View does not conform to UITableView datasource protocol")
    }
    
    func testThatTableViewHasDataSource() {
        
        XCTAssertNotNil(vc.tblArticle.dataSource, "Table datasource cannot be nil")
    }
    
    func testForUITableViewDelegate() {
        
        XCTAssertTrue(vc != nil, "View does not conform to UITableView delegate protocol")
    }
    
    func testTableViewIsConnectedToDelegate() {
        
        XCTAssertNotNil(vc.tblArticle.delegate, "Table delegate cannot be nil")
    }
    
    func testForAPI() {
        let url = URL(string : ApiConstant.mainDomain + ApiConstant.apiKey)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                XCTAssert(false)
            }
            
            guard let data = data else {
                XCTAssert(false)
                return
            }
            guard let _ = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                XCTAssert(false)
                return
            }
            XCTAssert(true)
            }.resume()
    }
}
