//
//  EPUBKitTests.swift
//  EPUBKit Tests
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import XCTest
import EPUBKit

class EPUBKitTests: XCTestCase {

    private let library: FileLibrary = EPUBLibrary()

}

extension EPUBKitTests {

    /// Testing EPUBDocument.init(url:)
    func testEPUBDocumentSimpleInitialiserWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        guard let document = EPUBDocument(url: url)
        else {
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
}

extension EPUBKitTests {

    /// Testing EPUBParser with EPUBParserDelegate
    func testEPUBParserDelegateWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        delegate.didBeginParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didUnzipArchiveTo = { _ in XCTAssertTrue(true) }
        delegate.didLocateContentAt = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingMetadata = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingManifest = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingSpine = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingTableOfContents = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didFailParsingDocument = { error in
            XCTFail("Parsing document did fail with error: \(error)")
        }
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        delegate.didBeginParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didUnzipArchiveTo = { _ in XCTAssertTrue(true) }
        delegate.didLocateContentAt = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingMetadata = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingManifest = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingSpine = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingTableOfContents = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didFailParsingDocument = { error in
            XCTFail("Parsing document did fail with error: \(error)")
        }
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateWithMetamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        delegate.didBeginParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didUnzipArchiveTo = { _ in XCTAssertTrue(true) }
        delegate.didLocateContentAt = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingMetadata = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingManifest = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingSpine = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingTableOfContents = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didFailParsingDocument = { error in
            XCTFail("Parsing document did fail with error: \(error)")
        }
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateWithBrokenAlice() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        delegate.didBeginParsingDocumentAt = { XCTAssertEqual(url, $0) }
        delegate.didUnzipArchiveTo = { _ in XCTAssertTrue(true) }
        delegate.didLocateContentAt = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingMetadata = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingManifest = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingSpine = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingTableOfContents = { _ in XCTAssertTrue(true) }
        delegate.didFinishParsingDocumentAt = { _ in XCTFail("Parsing should fail") }
        delegate.didFailParsingDocument = { _ in XCTAssertTrue(true) }
        parser.delegate = delegate
        XCTAssertThrowsError(try parser.parse(documentAt: url))
    }

}

extension EPUBKitTests {

    /// Testing EPUBParserDelegate default method implementations
    func testEPUBParserDelegateDefaultWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        let parser = EPUBParser()
        let delegate = MockedEmptyEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateDefaultWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        let parser = EPUBParser()
        let delegate = MockedEmptyEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateDefaultWithMethamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        let parser = EPUBParser()
        let delegate = MockedEmptyEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateDefaultWithProblemsofPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophy)
        let parser = EPUBParser()
        let delegate = MockedEmptyEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
    }
    func testEPUBParserDelegateDefaultWithBrokenAlice() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        let delegate = MockedEmptyEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertThrowsError(try parser.parse(documentAt: url))
    }

}

extension EPUBKitTests {

    func testErrorZipWithBrokenAlice() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        XCTAssertThrowsError(try parser.parse(documentAt: url), "") { error in
            guard let error = error as? EPUBParserError else {
                XCTFail("Error should be of type `EPUBParserError`")
                return
            }
            switch error {
            case .unzipFailed:
                XCTAssertNotNil(error.errorDescription)
                XCTAssertNotNil(error.failureReason)
                XCTAssertNotNil(error.recoverySuggestion)
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
    func testErrorContainerWithBrokenGeographyofBliss() {
        let url = library.path(for: .theGeographyofBlissBrokenContainer)
        let parser = EPUBParser()
        XCTAssertThrowsError(try parser.parse(documentAt: url), "") { error in
            guard let error = error as? EPUBParserError else {
                XCTFail("Error should be of type `EPUBParserError`")
                return
            }
            switch error {
            case .containerMissing:
                XCTAssertNotNil(error.errorDescription)
                XCTAssertNotNil(error.failureReason)
                XCTAssertNotNil(error.recoverySuggestion)
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
    func testErrorTocWithBrokenMetamorphosis() {
        let url = library.path(for: .theMetamorphosisBrokenToc)
        let parser = EPUBParser()
        XCTAssertThrowsError(try parser.parse(documentAt: url), "") { error in
            guard let error = error as? EPUBParserError else {
                XCTFail("Error should be of type `EPUBParserError`")
                return
            }
            switch error {
            case .tableOfContentsMissing:
                XCTAssertNotNil(error.errorDescription)
                XCTAssertNotNil(error.failureReason)
                XCTAssertNotNil(error.recoverySuggestion)
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
    func testErrorContentWithBrokenPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophyBrokenContent)
        let parser = EPUBParser()
        XCTAssertThrowsError(try parser.parse(documentAt: url), "") { error in
            guard let error = error as? EPUBParserError else {
                XCTFail("Error should be of type `EPUBParserError`")
                return
            }
            switch error {
            case .contentPathMissing:
                XCTAssertNotNil(error.errorDescription)
                XCTAssertNotNil(error.failureReason)
                XCTAssertNotNil(error.recoverySuggestion)
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
}
