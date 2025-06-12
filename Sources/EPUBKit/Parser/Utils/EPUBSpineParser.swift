//
//  EPUBSpineParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

/// Protocol defining the interface for parsing EPUB spine elements.
///
/// The spine parser is responsible for extracting the reading order information
/// from the spine element of the package document.
protocol EPUBSpineParser {
    /// Parses a spine XML element into an EPUBSpine object.
    ///
    /// - Parameter xmlElement: The spine XML element from the package document.
    /// - Returns: An `EPUBSpine` object containing the parsed reading order and configuration.
    func parse(_ xmlElement: AEXMLElement) -> EPUBSpine
}

/// Concrete implementation of `EPUBSpineParser` that parses the spine section.
///
/// The spine parser extracts the reading order of the publication as defined in EPUB
/// specification Section 3.4.12. The spine defines the default linear reading order
/// of the content documents and provides global configuration for page progression.
///
/// Expected spine XML structure:
/// ```xml
/// <spine toc="ncx" page-progression-direction="ltr">
///     <itemref idref="cover" linear="no"/>
///     <itemref idref="chapter1" linear="yes"/>
///     <itemref idref="chapter2" linear="yes"/>
///     <itemref idref="appendix" linear="no"/>
/// </spine>
/// ```
///
/// Key concepts:
/// - **Reading Order**: The sequence in which content should be presented to the reader
/// - **Linear vs Non-linear**: Linear items are part of the main reading flow, non-linear items are auxiliary
/// - **Page Progression**: The direction in which pages advance (left-to-right or right-to-left)
class EPUBSpineParserImplementation: EPUBSpineParser {

    /// Parses the spine XML element to extract reading order and configuration.
    ///
    /// The parsing process:
    /// 1. Extracts all `<itemref>` elements that define the reading order
    /// 2. Parses each itemref's attributes (idref, id, linear)
    /// 3. Extracts spine-level attributes (toc, page-progression-direction)
    /// 4. Creates EPUBSpineItem objects for each valid itemref
    ///
    /// According to the EPUB specification:
    /// - The `idref` attribute is required and must reference a manifest item ID
    /// - The `id` attribute is optional and provides a unique identifier for the itemref
    /// - The `linear` attribute is optional (defaults to "yes") and indicates if the item is part of the main reading flow
    /// - The `toc` attribute references the navigation document (NCX in EPUB 2)
    /// - The `page-progression-direction` attribute sets the global reading direction
    ///
    /// - Parameter xmlElement: The spine XML element from the package document.
    /// - Returns: An `EPUBSpine` object containing all parsed spine items and configuration.
    func parse(_ xmlElement: AEXMLElement) -> EPUBSpine {
        // Parse all itemref elements to build the reading order
        let items: [EPUBSpineItem] = xmlElement["itemref"].all?
            .compactMap { item in
                // The idref attribute is required - it must reference a manifest item
                if let idref = item.attributes["idref"] {
                    // Extract optional id attribute (rarely used in practice)
                    let id = item.attributes["id"]
                    
                    // Parse linear attribute - defaults to "yes" if not specified
                    // "yes" means the item is part of the main reading flow
                    // "no" means the item is auxiliary content (sidebars, footnotes, etc.)
                    let linear = (item.attributes["linear"] ?? "yes") == "yes"
                    
                    return EPUBSpineItem(id: id, idref: idref, linear: linear)
                } else {
                    // Skip itemref elements without idref (invalid according to spec)
                    return nil
                }
            } ?? []
        
        // Parse page progression direction from spine attributes
        // Defaults to "ltr" (left-to-right) if not specified
        // This is crucial for proper display of RTL languages like Arabic or Hebrew
        let direction = xmlElement["page-progression-direction"].value ?? "ltr"
        
        // Create and return the complete spine object
        return EPUBSpine(
            id: xmlElement.attributes["id"], // Optional spine ID
            toc: xmlElement.attributes["toc"], // Reference to navigation document
            pageProgressionDirection: EPUBPageProgressionDirection(
                rawValue: direction
            ), // Global reading direction
            items: items // Ordered list of content references
        )
    }

}
