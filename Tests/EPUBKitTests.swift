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

    var alice: URL!

    func testSimpleInitialiser() {
        guard let document = EPUBDocument(url: alice) else {
            XCTFail("Document should be parsed correctly.")
            return
        }
        XCTAssertNil(document.title)
        XCTAssertNil(document.author)
        XCTAssertNil(document.publisher)
        XCTAssertNil(document.cover)
    }

    override func setUp() {
        super.setUp()
        alice = Bundle(for: type(of: self)).resourceURL!.appendingPathComponent("alice.epub")
    }

}
