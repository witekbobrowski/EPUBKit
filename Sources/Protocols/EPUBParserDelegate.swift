//
//  EPUBParserDelegate.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 27/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

public protocol EPUBParserDelegate: AnyObject {
    func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL)
    func parser(_ parser: EPUBParser, didUnzipArchiveTo directory: URL)
    func parser(_ parser: EPUBParser, didLocateContentAt directory: URL)
    func parser(_ parser: EPUBParser, didFinishParsing metadata: EPUBMetadata)
    func parser(_ parser: EPUBParser, didFinishParsing manifest: EPUBManifest)
    func parser(_ parser: EPUBParser, didFinishParsing spine: EPUBSpine)
    func parser(_ parser: EPUBParser, didFinishParsing tableOfContents: EPUBTableOfContents)
    func parser(_ parser: EPUBParser, didFinishParsingDocumentAt path: URL)
    func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error)
}

public extension EPUBParserDelegate {
    func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL) {}
    func parser(_ parser: EPUBParser, didUnzipArchiveTo directory: URL) {}
    func parser(_ parser: EPUBParser, didLocateContentAt directory: URL) {}
    func parser(_ parser: EPUBParser, didFinishParsing metadata: EPUBMetadata) {}
    func parser(_ parser: EPUBParser, didFinishParsing manifest: EPUBManifest) {}
    func parser(_ parser: EPUBParser, didFinishParsing spine: EPUBSpine) {}
    func parser(_ parser: EPUBParser, didFinishParsing tableOfContents: EPUBTableOfContents) {}
    func parser(_ parser: EPUBParser, didFinishParsingDocumentAt path: URL) {}
    func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error) {}
}
