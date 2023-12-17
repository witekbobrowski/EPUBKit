//
//  EPUBDocumentTests.swift
//  
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import XCTest
@testable import EPUBKit

final class EPUBDocumentTests: XCTestCase {

    private lazy var library: FileLibrary = EPUBLibrary()

    func testEPUBDocumentSimpleInitialiserWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        guard let document = EPUBDocument(url: url) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertNil(document.title)
        XCTAssertNil(document.author)
        XCTAssertNil(document.publisher)
        XCTAssertNil(document.cover)
    }

    func testEPUBDocumentSimpleInitialiserWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertEqual(document.title, "The Geography of Bliss: One Grump's Search for the Happiest Places in the World")
        XCTAssertEqual(document.author, "Eric Weiner")
        XCTAssertEqual(document.publisher, "Twelve")
        XCTAssertNotNil(document.cover)
    }

    func testEPUBDocumentSimpleInitialiserWithMethamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        guard let document = EPUBDocument(url: url) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertEqual(document.title, "Metamorphosis")
        XCTAssertEqual(document.author, "Franz Kafka")
        XCTAssertEqual(document.publisher, "PressBooks.com")
        XCTAssertNotNil(document.cover)
    }

    func testEPUBDocumentSimpleInitialiserWithPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophy)
        guard let document = EPUBDocument(url: url) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertEqual(document.title, "The Problems of Philosophy")
        XCTAssertEqual(document.author, "Bertrand Russell")
        XCTAssertEqual(document.publisher, "PresssBooks.com")
        XCTAssertNotNil(document.cover)
    }
    
    // MARK: - Tests with data initializer
    func testEPUBDocumentSimpleInitialiserWithDataWithAliceInWonderland() throws {
        let url = library.path(for: .alicesAdventuresinWonderland)
        let data = try Data(contentsOf: url)
        guard let document = EPUBDocument(data: data) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertNil(document.title)
        XCTAssertNil(document.author)
        XCTAssertNil(document.publisher)
        XCTAssertNil(document.cover)
    }
    
    
    func testEPUBDocumentSimpleInitialiserWithDataWithPhilosophy() throws {
        let url = library.path(for: .theProblemsofPhilosophy)
        let data = try Data(contentsOf: url)
        guard let document = EPUBDocument(data: data) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertEqual(document.title, "The Problems of Philosophy")
        XCTAssertEqual(document.author, "Bertrand Russell")
        XCTAssertEqual(document.publisher, "PresssBooks.com")
        XCTAssertNotNil(document.cover)
    }
}
