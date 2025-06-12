//
//  EPUBManifestParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

/// Protocol defining the interface for parsing EPUB manifest elements.
///
/// The manifest parser is responsible for extracting resource information from the
/// manifest element of the package document.
protocol EPUBManifestParser {
    /// Parses a manifest XML element into an EPUBManifest object.
    ///
    /// - Parameter xmlElement: The manifest XML element from the package document.
    /// - Returns: An `EPUBManifest` containing all parsed manifest items.
    func parse(_ xmlElement: AEXMLElement) -> EPUBManifest
}

/// Concrete implementation of `EPUBManifestParser` that parses the manifest section.
///
/// The manifest parser extracts information about all resources in the EPUB publication
/// as defined in EPUB specification Section 3.4.11. The manifest lists every resource
/// in the publication, including content documents, stylesheets, images, fonts, and
/// other assets.
///
/// Expected manifest XML structure:
/// ```xml
/// <manifest>
///     <item id="chapter1" href="Text/chapter1.xhtml" media-type="application/xhtml+xml"/>
///     <item id="chapter2" href="Text/chapter2.xhtml" media-type="application/xhtml+xml" properties="nav"/>
///     <item id="css" href="Styles/main.css" media-type="text/css"/>
///     <item id="cover-image" href="Images/cover.jpg" media-type="image/jpeg" properties="cover-image"/>
///     <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
/// </manifest>
/// ```
class EPUBManifestParserImplementation: EPUBManifestParser {

    /// Parses the manifest XML element to extract all resource information.
    ///
    /// The parsing process:
    /// 1. Iterates through all `<item>` elements in the manifest
    /// 2. Extracts required attributes (id, href) and optional attributes (media-type, properties)
    /// 3. Creates `EPUBManifestItem` objects for each valid item
    /// 4. Stores items in a dictionary keyed by their ID for efficient lookup
    ///
    /// According to the EPUB specification:
    /// - The `id` attribute is required and must be unique within the manifest
    /// - The `href` attribute is required and contains the relative path to the resource
    /// - The `media-type` attribute is required and specifies the MIME type of the resource
    /// - The `properties` attribute is optional and contains space-separated property values
    ///
    /// - Parameter xmlElement: The manifest XML element from the package document.
    /// - Returns: An `EPUBManifest` containing all successfully parsed items, keyed by their IDs.
    func parse(_ xmlElement: AEXMLElement) -> EPUBManifest {
        // Dictionary to store manifest items, keyed by their ID for efficient lookup
        var items: [String: EPUBManifestItem] = [:]
        
        // Process all <item> elements within the manifest
        xmlElement["item"].all?
            .compactMap { item in
                // Extract required attributes: id and href
                // Skip items that don't have these required attributes
                guard
                    let id = item.attributes["id"],
                    let path = item.attributes["href"]
                else { return nil }
                
                // Parse the media-type attribute into an EPUBMediaType enum
                // If the media type is not recognized, it will be nil
                let mediaType = item.attributes["media-type"]
                    .map { EPUBMediaType(rawValue: $0) } ?? nil
                
                // Extract optional properties attribute
                // Properties can include values like "nav", "cover-image", "mathml", "svg", etc.
                let properties = item.attributes["properties"]
                
                // Create a manifest item with all extracted information
                // Unknown media types default to .unknown
                return EPUBManifestItem(
                    id: id, 
                    path: path, 
                    mediaType: mediaType ?? .unknown, 
                    property: properties
                )
            }
            .forEach { items[$0.id] = $0 } // Store each item in the dictionary using its ID as the key
        
        // Create and return the manifest with all parsed items
        // The manifest ID is extracted from the manifest element itself (if present)
        return EPUBManifest(id: xmlElement["id"].value, items: items)
    }

}
