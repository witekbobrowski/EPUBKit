//
//  EPUBContentService.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

/// Protocol defining the interface for accessing and parsing EPUB content documents.
///
/// This protocol provides access to the main components of an EPUB's package document
/// (OPF file) including metadata, manifest, and spine elements.
protocol EPUBContentService {
    /// The directory containing the EPUB's content files.
    ///
    /// This is typically the directory containing the OPF file and is used as the
    /// base path for resolving relative file references in the manifest.
    var contentDirectory: URL { get }
    
    /// The spine element from the package document.
    ///
    /// Contains the reading order of the publication as defined in the EPUB specification
    /// Section 3.4.12.
    var spine: AEXMLElement { get }
    
    /// The metadata element from the package document.
    ///
    /// Contains Dublin Core metadata and other publication metadata as defined in
    /// EPUB specification Section 3.4.5.
    var metadata: AEXMLElement { get }
    
    /// The manifest element from the package document.
    ///
    /// Lists all resources in the publication as defined in EPUB specification
    /// Section 3.4.11.
    var manifest: AEXMLElement { get }
    
    /// Initializes the content service with the extracted EPUB directory.
    ///
    /// - Parameter url: The URL of the extracted EPUB directory.
    /// - Throws: `EPUBParserError` if the container.xml or content.opf cannot be located or parsed.
    init(_ url: URL) throws
    
    /// Loads and parses the table of contents (NCX) file.
    ///
    /// - Parameter fileName: The relative path to the NCX file from the content directory.
    /// - Returns: The root element of the parsed NCX document.
    /// - Throws: An error if the NCX file cannot be loaded or parsed.
    func tableOfContents(_ fileName: String) throws -> AEXMLElement
}

/// Concrete implementation of `EPUBContentService` that locates and parses the package document.
///
/// This service is responsible for:
/// 1. Locating the package document (OPF file) using the container.xml
/// 2. Parsing the package document to provide access to metadata, manifest, and spine
/// 3. Loading additional content files like the NCX navigation document
///
/// The service follows the EPUB Open Container Format (OCF) specification for locating
/// the package document through the META-INF/container.xml file.
class EPUBContentServiceImplementation: EPUBContentService {

    /// The parsed package document (OPF file).
    ///
    /// This document contains all the metadata, manifest, and spine information
    /// for the EPUB publication.
    private var content: AEXMLDocument

    /// The directory containing the EPUB's content files.
    ///
    /// This is the directory where the OPF file is located and serves as the base
    /// for resolving relative paths in the manifest.
    let contentDirectory: URL

    /// Provides access to the spine element from the package document.
    ///
    /// The spine defines the default reading order of the publication.
    /// Structure example:
    /// ```xml
    /// <spine toc="ncx">
    ///     <itemref idref="chapter1" linear="yes"/>
    ///     <itemref idref="chapter2" linear="yes"/>
    /// </spine>
    /// ```
    var spine: AEXMLElement { content.root["spine"] }
    
    /// Provides access to the metadata element from the package document.
    ///
    /// Contains Dublin Core elements and other metadata.
    /// Structure example:
    /// ```xml
    /// <metadata>
    ///     <dc:title>Book Title</dc:title>
    ///     <dc:creator>Author Name</dc:creator>
    ///     <dc:language>en</dc:language>
    /// </metadata>
    /// ```
    var metadata: AEXMLElement { content.root["metadata"] }
    
    /// Provides access to the manifest element from the package document.
    ///
    /// Lists all resources in the publication.
    /// Structure example:
    /// ```xml
    /// <manifest>
    ///     <item id="chapter1" href="chapter1.xhtml" media-type="application/xhtml+xml"/>
    ///     <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    /// </manifest>
    /// ```
    var manifest: AEXMLElement { content.root["manifest"] }

    /// Initializes the content service by locating and parsing the package document.
    ///
    /// The initialization process:
    /// 1. Reads META-INF/container.xml to find the package document location
    /// 2. Loads and parses the package document (OPF file)
    /// 3. Stores the content directory for resolving relative paths
    ///
    /// - Parameter url: The URL of the extracted EPUB directory.
    /// - Throws: `EPUBParserError.containerMissing` if container.xml is not found,
    ///           `EPUBParserError.contentPathMissing` if the OPF path is not specified,
    ///           or XML parsing errors if the documents are malformed.
    required init(_ url: URL) throws {
        // STEP 1: Locate the package document using OCF container.xml
        // This follows the EPUB Open Container Format specification which mandates
        // that the container.xml file in META-INF/ points to the OPF location
        let path = try Self.getContentPath(from: url)
        
        // STEP 2: Determine the content directory (base path for relative references)
        // The content directory is crucial because all href attributes in the manifest
        // are resolved relative to the directory containing the OPF file
        contentDirectory = path.deletingLastPathComponent()
        
        // STEP 3: Load and parse the package document (OPF file)
        // This XML document contains the complete publication metadata, manifest, and spine
        let data = try Data(contentsOf: path)
        content = try AEXMLDocument(xml: data)
    }

    /// Loads and parses the table of contents (NCX) file.
    ///
    /// The NCX (Navigation Control file for XML applications) provides hierarchical
    /// navigation information for the EPUB. This method loads the NCX file specified
    /// in the spine's toc attribute.
    ///
    /// - Parameter fileName: The relative path to the NCX file from the content directory.
    /// - Returns: The root element of the parsed NCX document.
    /// - Throws: An error if the file cannot be loaded or if the XML is malformed.
    func tableOfContents(_ fileName: String) throws -> AEXMLElement {
        // Construct the full path to the NCX file using the content directory as base
        // This ensures proper resolution of the relative path from the manifest
        let path = contentDirectory.appendingPathComponent(fileName)
        
        // Load and parse the NCX document
        // NCX files can be quite large for books with detailed navigation,
        // but we load the entire document to enable efficient XPath-like queries
        let data = try Data(contentsOf: path)
        return try AEXMLDocument(xml: data).root
    }

}

extension EPUBContentServiceImplementation {

    /// Locates the package document path from the container.xml file.
    ///
    /// According to the EPUB OCF specification, the container.xml file in the META-INF
    /// directory must point to the location of the package document (OPF file).
    ///
    /// Expected container.xml structure:
    /// ```xml
    /// <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
    ///     <rootfiles>
    ///         <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
    ///     </rootfiles>
    /// </container>
    /// ```
    ///
    /// - Parameter url: The URL of the extracted EPUB directory.
    /// - Returns: The full URL to the package document (OPF file).
    /// - Throws: `EPUBParserError.containerMissing` if container.xml cannot be found,
    ///           `EPUBParserError.contentPathMissing` if the full-path attribute is missing.
    static private func getContentPath(from url: URL) throws -> URL {
        // STEP 1: Construct path to container.xml according to OCF specification
        // The OCF spec mandates this exact location and filename
        let path = url.appendingPathComponent("META-INF/container.xml")
        
        // STEP 2: Attempt to load container.xml with graceful error handling
        // We use optional try to convert file system errors to our domain-specific error
        // This provides better error messages to users than generic file system errors
        guard let data = try? Data(contentsOf: path) else {
            throw EPUBParserError.containerMissing
        }
        
        // STEP 3: Parse container.xml to find the package document location
        // Container.xml is typically small, so parsing the entire document is efficient
        let container = try AEXMLDocument(xml: data)
        
        // STEP 4: Extract the OPF path from the first rootfile element
        // EPUB spec allows multiple rootfiles, but we follow the common practice
        // of using the first one. The full-path is relative to the EPUB root.
        // This design allows EPUBs to organize content in subdirectories (e.g., "OEBPS/")
        guard let content = container.root["rootfiles"]["rootfile"].attributes["full-path"] else {
            throw EPUBParserError.contentPathMissing
        }
        
        // STEP 5: Return the complete absolute path to the package document
        // This combines the EPUB root with the relative OPF path from container.xml
        return url.appendingPathComponent(content)
    }

}
