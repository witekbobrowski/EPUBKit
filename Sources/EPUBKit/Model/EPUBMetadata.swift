//
//  EPUBMetadata.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents the metadata section of an EPUB publication.
///
/// The metadata conforms to the EPUB 3 specification and includes:
/// - Required Dublin Core elements (identifier, title, language)
/// - Optional Dublin Core elements for bibliographic information
/// - EPUB-specific metadata like cover image references
///
/// All metadata elements use the Dublin Core Metadata Element Set
/// (http://dublincore.org/documents/dces/) with the "dc:" namespace prefix.
///
/// Reference: EPUB 3.3 Package Document § 5.2 Metadata
/// (https://www.w3.org/TR/epub-33/#sec-metadata-elem)
public struct EPUBMetadata {
    /// The contributor to the publication (dc:contributor).
    /// May include editors, illustrators, translators, etc.
    public var contributor: EPUBCreator?
    
    /// The spatial or temporal coverage of the publication (dc:coverage).
    public var coverage: String?
    
    /// The primary creator/author of the publication (dc:creator).
    /// EPUB 3 allows multiple creators with different roles.
    public var creator: EPUBCreator?
    
    /// The publication date (dc:date).
    /// Should follow W3CDTF format (subset of ISO 8601).
    public var date: String?
    
    /// A description of the publication content (dc:description).
    /// Often used for synopsis or abstract.
    public var description: String?
    
    /// The file format of the publication (dc:format).
    /// For EPUB, this is typically "application/epub+zip".
    public var format: String?
    
    /// The unique identifier for the publication (dc:identifier).
    /// This is a REQUIRED element in EPUB. Often an ISBN, DOI, or UUID.
    public var identifier: String?
    
    /// The language of the publication content (dc:language).
    /// This is a REQUIRED element in EPUB. Uses RFC 5646 language tags.
    public var language: String?
    
    /// The publisher of the publication (dc:publisher).
    public var publisher: String?
    
    /// Related resources (dc:relation).
    /// References to related publications or resources.
    public var relation: String?
    
    /// Copyright and usage rights information (dc:rights).
    public var rights: String?
    
    /// The source publication from which this was derived (dc:source).
    /// Used when the EPUB is based on another work.
    public var source: String?
    
    /// The subject/topic of the publication (dc:subject).
    /// Keywords or classification codes.
    public var subject: String?
    
    /// The title of the publication (dc:title).
    /// This is a REQUIRED element in EPUB.
    public var title: String?
    
    /// The type/genre of the publication (dc:type).
    /// Typically uses DCMI Type Vocabulary.
    public var type: String?
    
    /// The ID of the cover image in the manifest.
    /// Referenced by a meta element with name="cover" in the OPF.
    /// This is EPUB-specific metadata, not part of Dublin Core.
    public var coverId: String?
}
