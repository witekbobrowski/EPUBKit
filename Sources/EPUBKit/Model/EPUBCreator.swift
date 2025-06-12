//
//  EPUBCreator.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents a person or organization responsible for creating or contributing to an EPUB publication.
///
/// Used for both dc:creator and dc:contributor elements in EPUB metadata.
/// EPUB 3 allows specifying additional attributes beyond just the name,
/// including the role and filing order.
///
/// Reference: EPUB 3.3 Package Document § 5.2.2 DCMES Elements
/// (https://www.w3.org/TR/epub-33/#sec-opf-dcmes)
public struct EPUBCreator {
    /// The name of the creator or contributor.
    /// This is the primary display name for the person or organization.
    public var name: String?
    
    /// The role of the creator in the publication.
    /// 
    /// Common roles include:
    /// - "aut" (author)
    /// - "edt" (editor)
    /// - "ill" (illustrator)
    /// - "trl" (translator)
    /// 
    /// Uses MARC Code List for Relators:
    /// https://www.loc.gov/marc/relators/relaterm.html
    public var role: String?
    
    /// The filing/sorting version of the name.
    /// 
    /// Used for alphabetical ordering in catalogs and indexes.
    /// For example, "King, Stephen" for author "Stephen King".
    /// 
    /// Corresponds to the opf:file-as attribute in OPF metadata.
    public var fileAs: String?
}
