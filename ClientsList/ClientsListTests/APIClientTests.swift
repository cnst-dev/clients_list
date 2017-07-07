//
//  APIClientTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 07.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class APIClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Login_UsesExpectedURL() {
        let sut = APIClient()

        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)

        sut.session = mockURLSession

        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName: "dasdöm", password: "%&34", completion: completion)

        guard let url = mockURLSession.url else {
            XCTFail("There should be an URL")
            return
        }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)

        XCTAssertEqual(urlComponents?.host, "clientslist.io")
        XCTAssertEqual(urlComponents?.path, "/login")

        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted

        guard let expectedUsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            XCTFail("There should be an expected username")
            return
        }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            XCTFail("There should be an expected username")
            return
        }

        XCTAssertEqual(urlComponents?.percentEncodedQuery, "username=\(expectedUsername)&password=\(expectedPassword)")
    }

    func test_Login_WhenSuccessful_CreatesToken() {
        let sut = APIClient()

        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession

        let tokenExpectation = expectation(description: "Token")

        var catchedToken: Token?
        sut.loginUser(withName: "Name", password: "pass") { (token, _) in
            catchedToken = token
            tokenExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertEqual(catchedToken?.id, "1234567890")
        }

    }

    func test_Login_WhenJSONIsInvalid_ReturnsError() {
        let sut = APIClient()

        let mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error?

        sut.loginUser(withName: "Name", password: "pass") { (_, error) in
            catchedError = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }

    func test_Login_WhenDataIsNil_ReturnsError() {
        let sut = APIClient()

        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error?

        sut.loginUser(withName: "Name", password: "pass") { (_, error) in
            catchedError = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }

    func test_Login_WhenResponseHasError_ReturnsError() {
        let sut = APIClient()

        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)

        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)

        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: error)
        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error?

        sut.loginUser(withName: "Name", password: "pass") { (_, error) in
            catchedError = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }
}

extension APIClientTests {

    class MockURLSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }

        func dataTask(
            with url: URL, completionHandler:
            @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url

            dataTask.completionHandler = completionHandler
            return dataTask
        }

    }

    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?

        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

        var completionHandler: CompletionHandler?

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }

        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }

    }
}
