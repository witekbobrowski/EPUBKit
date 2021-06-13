//
//  File.swift
//  
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import XCTest
@testable import EPUBKit

final class EPUBParserErrorTests: XCTestCase {

    private lazy var library: FileLibrary = EPUBLibrary()

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
                XCTFail("Wrong error thrown: \(error)")
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
                XCTFail("Wrong error thrown: \(error)")
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
                XCTFail("Wrong error thrown: \(error)")
            }
        }
    }

}
