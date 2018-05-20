//
//  MVVMBlogTests.swift
//  MVVMBlogTests
//
//  Created by Victor Zhong on 5/20/18.
//  Copyright © 2018 Erica Millado. All rights reserved.
//

import XCTest
@testable import MVVMBlog

class MVVMBlogTests: XCTestCase {
    var viewModel: ViewModel!
    var apiClientUnderTest: APIClient!

    override func setUp() {
        super.setUp()
        viewModel = ViewModel()


        apiClientUnderTest = APIClient()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "apple100", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/100/explicit.json")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        apiClientUnderTest.defaultSession = sessionMock

    }
    
    override func tearDown() {
        viewModel = nil
        apiClientUnderTest = nil
        super.tearDown()

    }
    


    func test_ViewModelResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")

        // when
//        XCTAssertEqual(viewModel.apps, nil, "searchResults should be empty before the data task runs")


        viewModel.getApps {
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertEqual(viewModel.apps?.count, 100, "Didn't parse 100 items from fake response")
    }

}
