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
    
    func test_properties_startEmpty() {
        let sut = makeSUT()
        XCTAssertEqual(sut.numbers, [])
        XCTAssertEqual(sut.uuids, [])
    }
    
    func test_set_doesNotResultInUncommittedChanges() {
        let sut = makeSUT()

        let someArray = [999]
        sut.set(numbers: someArray)

        let someUUIDArray = [UUID()]
        sut.set(uuids: someUUIDArray)
        
        let someKitchenSink = ["hello": "There"]
        sut.set(kitchenSink: someKitchenSink)
        
        XCTAssertFalse(sut.hasChanges, "expected false, got true. Are we sure we saved the data?")
    }
    
    func test_putSomethingInKitchenSink() throws {
        var sut: UserSettingsManager? = makeSUT()
        
        sut?.set(kitchenSink: ["say": "hey"])
        
        sut = nil
        sut = makeSUT()
        
        let dict = try XCTUnwrap(sut?.kitchenSink)
        let val = try XCTUnwrap(dict["say"] as? String)
        XCTAssertEqual(val, "hey")
    }
    
    // MARK: - Helpers
    func makeSUT() -> UserSettingsManager {
        UserSettingsManager(inMemory: true)
    }
}
