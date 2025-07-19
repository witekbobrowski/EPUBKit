//
//  EPUBParser.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML
import Kanna

/// The main parser class responsible for parsing EPUB documents.
///
/// EPUBParser orchestrates the complete parsing process by:
/// 1. Extracting the EPUB archive (if zipped)
/// 2. Locating the package document via META-INF/container.xml
/// 3. Parsing metadata, manifest, and spine from the package document
/// 4. Parsing the navigation document (NCX or XHTML nav)
///
/// The parser supports both zipped EPUB files and pre-extracted directories,
/// making it flexible for different use cases. It uses specialized sub-parsers
/// for each EPUB component to maintain separation of concerns.
///
/// Usage:
/// ```swift
/// let parser = EPUBParser()
/// parser.delegate = self // Optional: to receive parsing progress updates
/// let document = try parser.parse(documentAt: epubURL)
/// ```
///
/// Conforms to EPUB 3.3 specification while maintaining EPUB 2 compatibility.
public final class EPUBParser: EPUBParserProtocol {

    /// The XML element type used throughout parsing.
    /// AEXML provides a lightweight XML parsing solution.
    public typealias XMLElement = AEXMLElement

    /// Service for handling EPUB archive extraction.
    private let archiveService: EPUBArchiveService
    
    /// Parser for spine element and reading order.
    private let spineParser: EPUBSpineParser
    
    /// Parser for Dublin Core metadata elements.
    private let metadataParser: EPUBMetadataParser
    
    /// Parser for manifest items and resources.
    private let manifestParser: EPUBManifestParser
    
    /// Parser for NCX table of contents.
    private let tableOfContentsParser: EPUBTableOfContentsParser

    /// Optional delegate to receive parsing progress notifications.
    /// Set this before calling parse() to monitor the parsing process.
    public weak var delegate: EPUBParserDelegate?

    public init() {
        archiveService = EPUBArchiveServiceImplementation()
        metadataParser = EPUBMetadataParserImplementation()
        manifestParser = EPUBManifestParserImplementation()
        spineParser = EPUBSpineParserImplementation()
        tableOfContentsParser = EPUBTableOfContentsParserImplementation()
    }

    /// Parses an EPUB document at the specified URL.
    ///
    /// This method handles the complete EPUB parsing workflow:
    /// 1. Checks if the path is a directory or archive
    /// 2. Extracts archive if needed
    /// 3. Locates and parses the package document
    /// 4. Extracts all EPUB components (metadata, manifest, spine, TOC)
    ///
    /// - Parameter path: The file URL of the EPUB document (can be .epub file or extracted directory)
    /// - Returns: A fully parsed EPUBDocument with all components
    /// - Throws: EPUBParserError if any parsing step fails
    public func parse(documentAt path: URL) throws -> EPUBDocument {
        var directory: URL
        var contentDirectory: URL
        var metadata: EPUBMetadata
        var manifest: EPUBManifest
        var spine: EPUBSpine
        var tableOfContents: EPUBTableOfContents?
        
        // Notify delegate that parsing has begun
        delegate?.parser(self, didBeginParsingDocumentAt: path)

        do {
            // STEP 1: Handle both .epub files and pre-extracted directories
            // This flexibility allows the parser to work with both compressed archives
            // and directories that have already been extracted, which is useful for testing
            // and scenarios where the EPUB content is already available as files
            var isDirectory: ObjCBool = false
            FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory)
            
            // Extract archive if it's a .epub file, otherwise use the directory directly
            // This design pattern allows the same parsing logic to work with both formats
            directory = isDirectory.boolValue ? path : try unzip(archiveAt: path)
            delegate?.parser(self, didUnzipArchiveTo: directory)

            // STEP 2: Initialize content service - this is where the OCF container parsing happens
            // The content service is responsible for locating the OPF file through container.xml
            // and providing access to the parsed package document components
            let contentService = try EPUBContentServiceImplementation(directory)
            contentDirectory = contentService.contentDirectory
            delegate?.parser(self, didLocateContentAt: contentDirectory)

            // STEP 3: Parse core EPUB components in dependency order
            // Parse spine first as it contains the TOC reference needed later
            spine = getSpine(from: contentService.spine)
            delegate?.parser(self, didFinishParsing: spine)

            // Parse metadata for bibliographic information (Dublin Core)
            metadata = getMetadata(from: contentService.metadata)
            delegate?.parser(self, didFinishParsing: metadata)

            // Parse manifest to get the complete resource inventory
            manifest = getManifest(from: contentService.manifest)
            delegate?.parser(self, didFinishParsing: manifest)

            // STEP 4: Locate and parse table of contents using cross-references
            // The spine's 'toc' attribute references a manifest item ID
            // We use this to find the actual NCX file path in the manifest
            // This two-step lookup is required by the EPUB specification

			if let toc = spine.toc, let path = manifest.items[toc]?.path {
				let tableOfContentsElement = try contentService.tableOfContents(path)
				
				tableOfContents = getTableOfContents(from: tableOfContentsElement)
			} else if let path = manifest.items["nav"]?.path ?? manifest.items["toc"]?.path {
				let tocURL = contentDirectory.appendingPathComponent(path, isDirectory: false)
				
				tableOfContents = try? tableOfContentsParser.parse(navtocUrl: tocURL)
			}
        } catch let error {
            // CRITICAL: Always notify delegate of failures for proper error handling
            // This ensures that any cleanup or error reporting can be performed
            delegate?.parser(self, didFailParsingDocumentAt: path, with: error)
            throw error
        }
        
        // Notify delegate of successful completion
        delegate?.parser(self, didFinishParsingDocumentAt: path)
        
		guard let tableOfContents else {
			throw EPUBParserError.tableOfContentsMissing
		}
		
		delegate?.parser(self, didFinishParsing: tableOfContents)
        // Create and return the complete document with all parsed components
        return EPUBDocument(directory: directory, contentDirectory: contentDirectory,
                            metadata: metadata, manifest: manifest,
                            spine: spine, tableOfContents: tableOfContents)
    }

}

// MARK: - EPUBParsable Implementation
extension EPUBParser: EPUBParsable {

    /// Extracts an EPUB archive to a temporary directory.
    ///
    /// This method handles the decompression of .epub files, which are ZIP archives
    /// according to the EPUB OCF specification. The extraction process creates a
    /// temporary directory structure that mirrors the internal EPUB organization.
    ///
    /// - Parameter path: The URL of the EPUB archive file
    /// - Returns: URL of the directory containing extracted files
    /// - Throws: EPUBParserError.unzipFailed if extraction fails due to:
    ///           - Corrupted ZIP archive
    ///           - Insufficient disk space
    ///           - File system permission issues
    ///           - Invalid ZIP structure
    public func unzip(archiveAt path: URL) throws -> URL {
        // Delegate to the archive service which handles the actual ZIP extraction
        // This separation allows for easy testing and alternative archive implementations
        try archiveService.unarchive(archive: path)
    }

    /// Parses the spine element from package document XML.
    ///
    /// The spine defines the default reading order of the publication as specified
    /// in EPUB 3.3 Section 3.4.12. It references manifest items through idref attributes
    /// and may include a toc attribute pointing to the navigation document.
    ///
    /// - Parameter xmlElement: The spine XML element from the OPF package document
    /// - Returns: Parsed EPUBSpine with reading order and navigation references
    public func getSpine(from xmlElement: XMLElement) -> EPUBSpine {
        // Delegate to specialized spine parser which handles itemref elements
        // and extracts the table of contents reference
        spineParser.parse(xmlElement)
    }

    /// Parses the metadata element from package document XML.
    ///
    /// Extracts Dublin Core metadata elements as specified in EPUB 3.3 Section 3.4.5.
    /// This includes bibliographic information, creator details with MARC relator codes,
    /// and EPUB-specific metadata like cover references.
    ///
    /// - Parameter xmlElement: The metadata XML element from the OPF package document
    /// - Returns: Parsed EPUBMetadata with Dublin Core and OPF-specific elements
    public func getMetadata(from xmlElement: XMLElement) -> EPUBMetadata {
        // Delegate to specialized metadata parser which handles Dublin Core elements
        // and OPF-specific attributes like roles and file-as sorting
        metadataParser.parse(xmlElement)
    }

    /// Parses the manifest element from package document XML.
    ///
    /// The manifest lists all resources in the publication as specified in
    /// EPUB 3.3 Section 3.4.11. Each item includes an ID, href, and media-type,
    /// with optional properties for accessibility and fallback information.
    ///
    /// - Parameter xmlElement: The manifest XML element from the OPF package document
    /// - Returns: Parsed EPUBManifest with all publication resources indexed by ID
    public func getManifest(from xmlElement: XMLElement) -> EPUBManifest {
        // Delegate to specialized manifest parser which creates a lookup table
        // of all publication resources for efficient spine and TOC resolution
        manifestParser.parse(xmlElement)
    }

    /// Parses the NCX navigation document.
    ///
    /// Processes the Navigation Control file for XML applications (NCX) which provides
    /// hierarchical navigation structure. While NCX is primarily from EPUB 2, it's still
    /// supported in EPUB 3 for backward compatibility alongside XHTML nav documents.
    ///
    /// - Parameter xmlElement: The root ncx XML element from the navigation document
    /// - Returns: Hierarchical EPUBTableOfContents structure with recursive navigation points
    public func getTableOfContents(from xmlElement: XMLElement) -> EPUBTableOfContents {
        // Delegate to specialized TOC parser which recursively processes navPoint elements
        // to build the complete navigation hierarchy with unlimited nesting depth
        tableOfContentsParser.parse(xmlElement)
    }

}
