//
//  EPUBManifest.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents the manifest section of an EPUB package document.
///
/// The manifest provides an exhaustive list of all resources that compose the publication,
/// including content documents, stylesheets, images, fonts, scripts, and other media.
/// Each resource is identified by a unique ID and includes its location and media type.
///
/// According to EPUB 3 specification, the manifest MUST list every resource
/// used in the publication, with the exception of:
/// - The package document itself
/// - Resources in META-INF directory
/// - Resources retrieved from remote locations
///
/// Reference: EPUB 3.3 Package Document § 5.3 Manifest
/// (https://www.w3.org/TR/epub-33/#sec-manifest-elem)
public struct EPUBManifest {
    /// The optional ID attribute of the manifest element itself.
    /// Note: This is rarely used in practice.
    public var id: String?
    
    /// A dictionary mapping item IDs to their corresponding manifest items.
    /// 
    /// The key is the unique ID attribute from the manifest item element,
    /// which is used for internal references within the EPUB (e.g., from spine itemrefs).
    /// 
    /// Example manifest in OPF:
    /// ```xml
    /// <manifest>
    ///   <item id="chapter1" href="chapter1.xhtml" media-type="application/xhtml+xml"/>
    ///   <item id="cover-image" href="cover.jpg" media-type="image/jpeg" properties="cover-image"/>
    /// </manifest>
    /// ```
    public var items: [String: EPUBManifestItem]
}
