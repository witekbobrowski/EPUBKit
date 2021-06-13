//
//  MockedEPUBParserDelegate.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 01/07/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import EPUBKit

class MockedEmptyEPUBParserDelegate: EPUBParserDelegate {}

class MockedEPUBParserDelegate: EPUBParserDelegate {

    var didBeginParsingDocumentAt: ((URL) -> Void)?
    var didUnzipArchiveTo: ((URL) -> Void)?
    var didLocateContentAt: ((URL) -> Void)?
    var didFinishParsingMetadata: ((EPUBMetadata) -> Void)?
    var didFinishParsingManifest: ((EPUBManifest) -> Void)?
    var didFinishParsingSpine: ((EPUBSpine) -> Void)?
    var didFinishParsingTableOfContents: ((EPUBTableOfContents) -> Void)?
    var didFinishParsingDocumentAt: ((URL) -> Void)?
    var didFailParsingDocument: ((Error) -> Void)?

    func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL) {
        didBeginParsingDocumentAt?(path)
    }

    func parser(_ parser: EPUBParser, didUnzipArchiveTo directory: URL) {
        didUnzipArchiveTo?(directory)
    }

    func parser(_ parser: EPUBParser, didLocateContentAt directory: URL) {
        didLocateContentAt?(directory)
    }

    func parser(_ parser: EPUBParser, didFinishParsing metadata: EPUBMetadata) {
        didFinishParsingMetadata?(metadata)
    }

    func parser(_ parser: EPUBParser, didFinishParsing manifest: EPUBManifest) {
        didFinishParsingManifest?(manifest)
    }

    func parser(_ parser: EPUBParser, didFinishParsing spine: EPUBSpine) {
        didFinishParsingSpine?(spine)
    }

    func parser(_ parser: EPUBParser, didFinishParsing tableOfContents: EPUBTableOfContents) {
        didFinishParsingTableOfContents?(tableOfContents)
    }

    func parser(_ parser: EPUBParser, didFinishParsingDocumentAt path: URL) {
        didFinishParsingDocumentAt?(path)
    }

    func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error) {
        didFailParsingDocument?(error)
    }

}

