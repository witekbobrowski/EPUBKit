//
//  EPUBParser.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

public final class EPUBParser: EPUBParserProtocol {

    typealias XMLElement = AEXMLElement

    private let archiveService: EPUBArchiveService
    private let spineParser: EPUBSpineParser
    private let metadataParser: EPUBMetadataParser
    private let manifestParser: EPUBManifestParser
    private let tableOfContentsParser: EPUBTableOfContentsParser

    public weak var delegate: EPUBParserDelegate?

    public init() {
        archiveService = EPUBArchiveServiceImplementation()
        metadataParser = EPUBMetadataParserImplementation()
        manifestParser = EPUBManifestParserImplementation()
        spineParser = EPUBSpineParserImplementation()
        tableOfContentsParser = EPUBTableOfContentsParserImplementation()
    }

    public func parse(documentAt path: URL) throws -> EPUBDocument {
        do {
            delegate?.parser(self, didBeginParsingDocumentAt: path)

            let directory = try unzip(archiveAt: path)
            delegate?.parser(self, didUnzipArchiveTo: directory)

            let contentService = try EPUBContentServiceImplementation(directory)
            let contentDirectory = contentService.contentDirectory
            delegate?.parser(self, didLocateContentAt: contentDirectory)

            let spine =  getSpine(from: contentService.spine)
            delegate?.parser(self, didFinishParsing: spine)

            let metadata = getMetadata(from: contentService.metadata)
            delegate?.parser(self, didFinishParsing: metadata)

            let manifest = getManifest(from: contentService.manifest)
            delegate?.parser(self, didFinishParsing: manifest)

            let fileName = try manifest.path(forItemWithId: spine.toc ?? "")
            let tableOfContentsElement = try contentService.tableOfContents(fileName)
            let tableOfContents = getTableOfContents(from: tableOfContentsElement)
            delegate?.parser(self, didFinishParsing: tableOfContents)

            delegate?.parser(self, didFinishParsingDocumentAt: path)
            return EPUBDocument(directory: directory, contentDirectory: contentDirectory,
                                metadata: metadata, manifest: manifest,
                                spine: spine, tableOfContents: tableOfContents)
        } catch let error {
            delegate?.parser(self, didFailParsingDocumentAt: path, with: error)
            throw error
        }
    }

}

extension EPUBParser: EPUBParsable {

    func unzip(archiveAt path: URL) throws -> URL {
        return try archiveService.unarchive(archive: path)
    }

    func getSpine(from xmlElement: XMLElement) -> EPUBSpine {
        return spineParser.parse(xmlElement)
    }

    func getMetadata(from xmlElement: XMLElement) -> EPUBMetadata {
        return metadataParser.parse(xmlElement)
    }

    func getManifest(from xmlElement: XMLElement) -> EPUBManifest {
        return manifestParser.parse(xmlElement)
    }

    func getTableOfContents(from xmlElement: XMLElement) -> EPUBTableOfContents {
        return tableOfContentsParser.parse(xmlElement)
    }

}
