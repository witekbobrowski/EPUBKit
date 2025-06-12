//
//  EPUBParsable.swift
//  EPUBKit
//
//  Created by Witek on 19/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// A protocol defining the core parsing operations for EPUB documents.
///
/// EPUBParsable provides a contract for objects that can parse EPUB components
/// from XML elements. This protocol abstracts the XML parsing implementation,
/// allowing for different XML libraries while maintaining consistent interfaces.
///
/// The protocol uses an associated type for XML elements, enabling flexibility
/// in the underlying XML parsing framework. The current implementation uses
/// AEXML for lightweight XML processing.
///
/// Conforming types are responsible for:
/// - Archive extraction and file system operations
/// - Parsing specific EPUB components from XML
/// - Creating appropriate model objects from parsed data
///
/// This design supports the separation of concerns principle by isolating
/// parsing logic from model representation.
public protocol EPUBParsable {
    /// The type of XML element used for parsing operations.
    /// This associated type allows different XML parsing implementations
    /// while maintaining type safety throughout the parsing pipeline.
    associatedtype XMLElement

    /// Extracts an EPUB archive to access its contents.
    ///
    /// EPUB files are ZIP archives that need to be extracted before
    /// their internal structure can be parsed. This method handles
    /// the extraction process.
    ///
    /// - Parameter path: The file URL of the EPUB archive
    /// - Returns: URL of the directory containing extracted files
    /// - Throws: An error if extraction fails
    func unzip(archiveAt path: URL) throws -> URL
    
    /// Parses the spine element to determine reading order.
    ///
    /// The spine defines the default linear reading order of content
    /// documents in the EPUB. It references manifest items and may
    /// include global configuration like page progression direction.
    ///
    /// - Parameter xmlElement: The spine XML element from the package document
    /// - Returns: A parsed EPUBSpine containing reading order information
    func getSpine(from xmlElement: XMLElement) -> EPUBSpine
    
    /// Parses the metadata element containing bibliographic information.
    ///
    /// Metadata includes Dublin Core elements such as title, creator,
    /// language, and identifier, as well as EPUB-specific metadata
    /// like cover image references.
    ///
    /// - Parameter xmlElement: The metadata XML element from the package document
    /// - Returns: A parsed EPUBMetadata containing publication information
    func getMetadata(from xmlElement: XMLElement) -> EPUBMetadata
    
    /// Parses the manifest element listing all publication resources.
    ///
    /// The manifest provides an exhaustive list of files that make up
    /// the publication, including content documents, stylesheets, images,
    /// fonts, and other resources.
    ///
    /// - Parameter xmlElement: The manifest XML element from the package document
    /// - Returns: A parsed EPUBManifest containing resource information
    func getManifest(from xmlElement: XMLElement) -> EPUBManifest
    
    /// Parses the NCX navigation document for table of contents.
    ///
    /// The NCX (Navigation Control file for XML) provides hierarchical
    /// navigation information. While deprecated in EPUB 3, it's still
    /// widely used and supported for backwards compatibility.
    ///
    /// - Parameter xmlElement: The root ncx XML element
    /// - Returns: A hierarchical EPUBTableOfContents structure
    func getTableOfContents(from xmlElement: XMLElement) -> EPUBTableOfContents
}
