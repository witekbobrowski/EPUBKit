//
//  EPUBParserDelegateTests.swift
//  
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import XCTest
@testable import EPUBKit

final class EPUBParserDelegateTests: XCTestCase {

    private lazy var library: FileLibrary = EPUBLibrary()

    // MARK: - Delegate with implemented methods

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
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
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
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
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
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
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
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
    }

    // MARK: - Delegate is nil

    func testEPUBParserDelegateNilWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNil(parser.delegate)
    }

    func testEPUBParserDelegateNilWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNil(parser.delegate)
    }

    func testEPUBParserDelegateNilWithMethamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNil(parser.delegate)
    }

    func testEPUBParserDelegateNilWithProblemsofPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophy)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNil(parser.delegate)
    }

    func testEPUBParserDelegateNilWithBrokenAlice() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertThrowsError(try parser.parse(documentAt: url))
        XCTAssertNil(parser.delegate)
    }

    func testEPUBParserDelegateDefaultWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        let parser = EPUBParser()
        parser.delegate = nil
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNil(parser.delegate)
    }

    // MARK: - Delegate with empty implementations

    func testEPUBParserDelegateDefaultWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        withExtendedLifetime(delegate, {})
    }

    func testEPUBParserDelegateDefaultWithMethamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
    }

    func testEPUBParserDelegateDefaultWithProblemsofPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophy)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertNoThrow(try parser.parse(documentAt: url), "Document should be parsed correctly.")
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
    }

    func testEPUBParserDelegateDefaultWithBrokenAlice() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        parser.delegate = delegate
        XCTAssertThrowsError(try parser.parse(documentAt: url))
        XCTAssertNotNil(parser.delegate)
        withExtendedLifetime(delegate, {})
    }

}
