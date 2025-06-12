//
//  EPUBManifestItem.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents a single item element within the EPUB manifest.
///
/// Each manifest item describes a resource that is part of the publication,
/// including its location, media type, and optional properties.
///
/// Example item element in OPF:
/// ```xml
/// <item id="chapter1" 
///       href="Text/chapter1.xhtml" 
///       media-type="application/xhtml+xml"
///       properties="nav"/>
/// ```
///
/// Reference: EPUB 3.3 Package Document § 5.3.2 The item Element
/// (https://www.w3.org/TR/epub-33/#sec-item-elem)
public struct EPUBManifestItem {
    /// The unique identifier for this resource within the manifest.
    /// This ID is used for internal references, such as from spine itemrefs.
    /// REQUIRED attribute in EPUB specification.
    public var id: String
    
    /// The relative path to the resource file.
    /// 
    /// The path is relative to the package document location (content.opf).
    /// Uses forward slashes as path separators regardless of platform.
    /// Corresponds to the "href" attribute in the item element.
    public var path: String
    
    /// The MIME media type of the resource.
    /// 
    /// Indicates the type of content (e.g., XHTML, CSS, JPEG).
    /// EPUB 3 defines Core Media Types that must be supported by all reading systems.
    /// Corresponds to the "media-type" attribute.
    public var mediaType: EPUBMediaType
    
    /// Optional space-separated list of property values.
    /// 
    /// Common properties include:
    /// - "cover-image": Identifies the publication cover image
    /// - "nav": Identifies the EPUB 3 navigation document
    /// - "scripted": Indicates the resource contains scripting
    /// - "mathml": Indicates the resource contains MathML
    /// - "svg": Indicates the resource contains SVG
    public var property: String?
}
