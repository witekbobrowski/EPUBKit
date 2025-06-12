//
//  EPUBTableOfContents.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents the hierarchical table of contents for EPUB navigation.
///
/// This structure is based on the NCX (Navigation Control file for XML) format
/// from EPUB 2, which is still supported in EPUB 3 for backwards compatibility.
/// EPUB 3 introduces a new XHTML-based navigation document, but NCX remains
/// widely used.
///
/// The table of contents provides a hierarchical view of the publication's
/// structure, allowing readers to navigate directly to specific sections.
///
/// NCX Structure Example:
/// ```xml
/// <navMap>
///   <navPoint id="ch1" playOrder="1">
///     <navLabel><text>Chapter 1</text></navLabel>
///     <content src="chapter1.xhtml"/>
///     <navPoint id="ch1.1" playOrder="2">
///       <navLabel><text>Section 1.1</text></navLabel>
///       <content src="chapter1.xhtml#sec1"/>
///     </navPoint>
///   </navPoint>
/// </navMap>
/// ```
///
/// Reference: EPUB 3.3 Packages § 4.2.2 The NCX
/// (https://www.w3.org/TR/epub-packages-32/#sec-ncx)
public struct EPUBTableOfContents {
    /// The display text for this navigation point.
    /// 
    /// Extracted from the navLabel/text element in NCX.
    /// This is what readers see in the table of contents.
    public var label: String
    
    /// The unique identifier for this navigation point.
    /// 
    /// Corresponds to the id attribute of the navPoint element.
    /// Used for internal referencing and state preservation.
    public var id: String
    
    /// The content location this navigation point links to.
    /// 
    /// From the content element's src attribute in NCX.
    /// Can include fragment identifiers (e.g., "chapter1.xhtml#section2").
    public var item: String?
    
    /// Child navigation points for hierarchical structure.
    /// 
    /// Represents nested navPoint elements in NCX.
    /// Allows multi-level table of contents (chapters > sections > subsections).
    public var subTable: [EPUBTableOfContents]?
}
