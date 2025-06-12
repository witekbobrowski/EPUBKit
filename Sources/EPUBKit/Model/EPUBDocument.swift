//
//  EPUBDocument.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// The main representation of an EPUB publication.
/// 
/// An EPUB document consists of multiple components as defined in the EPUB 3 specification:
/// - A container that packages all resources (ZIP format)
/// - Metadata describing the publication (Dublin Core elements)
/// - A manifest listing all resources in the publication
/// - A spine defining the default reading order
/// - Navigation documents for user navigation (table of contents)
///
/// This struct provides access to all parsed components of an EPUB file,
/// conforming to the EPUB 3.3 specification (https://www.w3.org/TR/epub-33/).
public struct EPUBDocument {

    /// The root directory where the EPUB was extracted.
    public let directory: URL
    
    /// The content directory containing the actual publication resources.
    /// This is determined by parsing the META-INF/container.xml file.
    public let contentDirectory: URL
    
    /// The publication metadata containing bibliographic information.
    /// Includes required elements like title, identifier, and language,
    /// as well as optional Dublin Core metadata elements.
    public let metadata: EPUBMetadata
    
    /// The manifest containing references to all publication resources.
    /// Each resource is identified by a unique ID and includes its media type.
    public let manifest: EPUBManifest
    
    /// The spine defining the default reading order of content documents.
    /// References items from the manifest to establish linear reading progression.
    public let spine: EPUBSpine
    
    /// The hierarchical table of contents for navigation.
    /// Based on the NCX (Navigation Control file for XML) format for EPUB 2 compatibility,
    /// though EPUB 3 uses XHTML navigation documents.
    public let tableOfContents: EPUBTableOfContents

    init(
        directory: URL,
        contentDirectory: URL,
        metadata: EPUBMetadata,
        manifest: EPUBManifest,
        spine: EPUBSpine,
        tableOfContents: EPUBTableOfContents
    ) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = tableOfContents
    }

    /// Creates an EPUBDocument by parsing the EPUB file at the specified URL.
    /// 
    /// This convenience initializer handles the complete parsing process:
    /// 1. Extracts the EPUB archive (if needed)
    /// 2. Locates the package document via META-INF/container.xml
    /// 3. Parses all EPUB components (metadata, manifest, spine, navigation)
    /// 
    /// - Parameter url: The file URL of the EPUB document to parse.
    /// - Returns: A parsed EPUBDocument, or nil if parsing fails.
    public init?(url: URL) {
        guard let document = try? EPUBParser().parse(documentAt: url) else {
            return nil
        }
        self = document
    }

}

// MARK: - Convenience Properties
extension EPUBDocument {
    /// The publication title from the metadata.
    /// Corresponds to the required dc:title element in the OPF package document.
    public var title: String? { metadata.title }
    
    /// The primary author/creator name.
    /// Extracted from the dc:creator element if present.
    public var author: String? { metadata.creator?.name }
    
    /// The publisher name from the metadata.
    /// Corresponds to the dc:publisher element.
    public var publisher: String? { metadata.publisher }
    
    /// The URL to the cover image file.
    /// 
    /// The cover is identified by:
    /// 1. A meta element with name="cover" in the OPF metadata
    /// 2. The corresponding manifest item with the referenced ID
    /// 
    /// - Returns: The full URL to the cover image, or nil if no cover is specified.
    public var cover: URL? {
        guard let coverId = metadata.coverId, let path = manifest.items[coverId]?.path else {
            return nil
        }
        return contentDirectory.appendingPathComponent(path)
    }
}
