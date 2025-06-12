//
//  EPUBSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents the spine element of an EPUB package document.
///
/// The spine defines the default reading order of the EPUB publication by
/// providing an ordered list of manifest items. Each itemref in the spine
/// references a content document from the manifest.
///
/// The spine enables Reading Systems to present the content in a specific
/// linear sequence, though items can be marked as non-linear to indicate
/// they're auxiliary content (e.g., footnotes, sidebars).
///
/// Example spine in OPF:
/// ```xml
/// <spine toc="ncx" page-progression-direction="ltr">
///   <itemref idref="cover" linear="no"/>
///   <itemref idref="chapter1"/>
///   <itemref idref="chapter2"/>
/// </spine>
/// ```
///
/// Reference: EPUB 3.3 Package Document § 5.4 Spine
/// (https://www.w3.org/TR/epub-33/#sec-spine-elem)
public struct EPUBSpine {
    /// The optional ID attribute of the spine element.
    /// Rarely used in practice.
    public var id: String?
    
    /// Reference to the table of contents.
    /// 
    /// In EPUB 2, this references the NCX document ID in the manifest.
    /// EPUB 3 deprecates this in favor of the nav document, but it's
    /// still included for backwards compatibility.
    public var toc: String?
    
    /// The global page progression direction.
    /// 
    /// Specifies the global direction in which content flows,
    /// particularly important for languages with right-to-left scripts.
    public var pageProgressionDirection: EPUBPageProgressionDirection?
    
    /// An ordered list of spine items defining the reading order.
    /// 
    /// Each item references a content document from the manifest.
    /// The order of items determines the default reading sequence.
    public var items: [EPUBSpineItem]
}

/// Defines the page progression direction for the publication.
///
/// This affects how pages are arranged and navigated in Reading Systems,
/// particularly important for proper display of different writing systems.
///
/// Reference: EPUB 3.3 Package Document § 5.4.1.2 page-progression-direction
public enum EPUBPageProgressionDirection: String {
    /// Left-to-right page progression (default).
    /// Used for most Western languages.
    case leftToRight = "ltr"
    
    /// Right-to-left page progression.
    /// Used for Arabic, Hebrew, and other RTL scripts.
    case rightToLeft = "rtl"
}
