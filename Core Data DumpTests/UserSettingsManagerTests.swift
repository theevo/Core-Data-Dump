//
//  UserSettingsManagerTests.swift
//  Core Data Dump
//
//  Created by Theo Vora on 7/7/23.
//

import XCTest
@testable import Core_Data_Dump

final class UserSettingsManagerTests: XCTestCase {
    func test_initWithInMemory_persistentContainerPathIsDevNull() {
        let sut = makeSUT()
        let url = sut.controller.container.persistentStoreDescriptions.first?.url
        XCTAssertTrue(((url?.absoluteString.contains("/dev/null")) != nil))
    }
    
    // MARK: - Helpers
    func makeSUT() -> UserSettingsManager {
        UserSettingsManager(inMemory: true)
    }
}
