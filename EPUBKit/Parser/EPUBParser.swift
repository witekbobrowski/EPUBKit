//
//  EPUBParser.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import AEXML
import Foundation

public final class EPUBParser: EPUBParserProtocol {

    private let archiveService: EPUBArchiveService
    private let metadataParser: EPUBMetadataParser
    private let manifestParser: EPUBManifestParser
    private let spineParser: EPUBSpineParser
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

            let contentPath = try getContentPath(from: directory)
            let contentDirectory = contentPath.deletingLastPathComponent()
            let content = try AEXMLDocument(xml: try Data(contentsOf: contentPath))

            let metadata = getMetadata(from: content.root["metadata"])
            delegate?.parser(self, didFinishParsing: metadata)

            let manifest = getManifest(from: content.root["manifest"])
            delegate?.parser(self, didFinishParsing: manifest)

            let spine =  getSpine(from: content.root["spine"])
            delegate?.parser(self, didFinishParsing: spine)

            let tocPathComponent = try manifest.path(forItemWithId: spine.toc ?? "")
            let tocPath = contentDirectory.appendingPathComponent(tocPathComponent)
            let tocData = try Data(contentsOf: tocPath)
            let tocContent = try AEXMLDocument(xml: tocData)
            let tableOfContents = getTableOfContents(from: tocContent.root)
            delegate?.parser(self, didFinishParsing: tableOfContents)

            delegate?.parser(self, didFinishParsingDocumentAt: path)
            return EPUBDocument(directory: directory,
                                contentDirectory: contentDirectory,
                                metadata: metadata,
                                manifest: manifest,
                                spine: spine,
                                tableOfContents: tableOfContents)
        } catch let error {
            delegate?.parser(self, didFailParsingDocumentAt: path, with: error)
            throw error
        }
    }

}

// MARK: - EPUBParsable
extension EPUBParser: EPUBParsable {

    func unzip(archiveAt path: URL) throws -> URL {
        return try archiveService.unarchive(archive: path)
    }

    func getContentPath(from documentPath: URL) throws -> URL {
        do {
            let path = documentPath.appendingPathComponent("META-INF/container.xml")
            let data = try Data(contentsOf: path)
            let container = try AEXMLDocument(xml: data)
            let content = container.root["rootfiles"]["rootfile"].attributes["full-path"]
            return documentPath.appendingPathComponent(content!)
        } catch {
            throw EPUBParserError.containerParseError
        }
    }

    func getMetadata(from xmlElement: AEXMLElement) -> EPUBMetadata {
        return metadataParser.parse(xmlElement)
    }

    func getManifest(from xmlElement: AEXMLElement) -> EPUBManifest {
        return manifestParser.parse(xmlElement)
    }

    func getSpine(from xmlElement: AEXMLElement) -> EPUBSpine {
        return spineParser.parse(xmlElement)
    }

    func getTableOfContents(from xmlElement: AEXMLElement) -> EPUBTableOfContents {
        return tableOfContentsParser.parse(xmlElement)
    }

}
