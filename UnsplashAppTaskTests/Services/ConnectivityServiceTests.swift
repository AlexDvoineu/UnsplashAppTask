//
//  ConnectivityServiceTests.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 16.10.23.
//

@testable import UnsplashAppTask
import XCTest

final class ConnectivityServiceTests: XCTestCase {
    
    func testUnknownState() {
        testConnectivity(state: .unknown, hasMessage: .defaultSwiftMessagesLabelText)
    }
    
    func testSatisfiedState() {
        testConnectivity(state: .satisfied, hasMessage: .defaultSwiftMessagesLabelText)
    }
    
    func testRestrictedCellularState() {
        testConnectivity(state: .restrictedCellular, hasMessage: "Enable Cellular Data for Lockdown")
    }
    
    func testNoConnectionState() {
        testConnectivity(state: .noConnection, hasMessage: "No Internet Connection")
    }
    
    private func testConnectivity(state: ConnectionState, hasMessage message: String) {
        // Given
        let connectivityService = ConnectivityService(connectionState: state)
        
        // When
        connectivityService.showConnectionErrorIfNeeded()
        
        let expectation = expectation(description: "ConnectivityService uses main.async, so we test it there")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // Then
        XCTAssertEqual(connectivityService.noInternetMessageView.bodyLabel?.text, message)
    }
}

private extension String {
    static let defaultSwiftMessagesLabelText = "[Message Body]"
}
