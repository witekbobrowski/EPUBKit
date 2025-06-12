//
//  EPUBMetadataParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

/// Protocol defining the interface for parsing EPUB metadata elements.
///
/// The metadata parser is responsible for extracting Dublin Core metadata and
/// EPUB-specific metadata from the metadata element of the package document.
protocol EPUBMetadataParser {
    /// Parses a metadata XML element into an EPUBMetadata object.
    ///
    /// - Parameter xmlElement: The metadata XML element from the package document.
    /// - Returns: An `EPUBMetadata` object containing all parsed metadata information.
    func parse(_ xmlElement: AEXMLElement) -> EPUBMetadata
}

/// Concrete implementation of `EPUBMetadataParser` that extracts Dublin Core metadata.
///
/// This parser extracts metadata from the package document as defined in EPUB specification
/// Section 3.4.5. It handles Dublin Core elements (prefixed with `dc:`) and OPF-specific
/// metadata elements (prefixed with `opf:` or using `<meta>` elements).
///
/// Expected metadata XML structure:
/// ```xml
/// <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
///     <dc:title>Book Title</dc:title>
///     <dc:creator opf:role="aut" opf:file-as="Last, First">Author Name</dc:creator>
///     <dc:contributor opf:role="edt">Editor Name</dc:contributor>
///     <dc:identifier id="uuid_id" opf:scheme="uuid">urn:uuid:12345678-1234-1234-1234-123456789012</dc:identifier>
///     <dc:language>en</dc:language>
///     <dc:date>2023-01-01</dc:date>
///     <dc:publisher>Publisher Name</dc:publisher>
///     <dc:description>Book description</dc:description>
///     <dc:subject>Fiction</dc:subject>
///     <dc:rights>Copyright information</dc:rights>
///     <meta name="cover" content="cover-image"/>
/// </metadata>
/// ```
///
/// The Dublin Core Metadata Element Set provides a vocabulary of fifteen properties
/// for describing digital and physical resources.
class EPUBMetadataParserImplementation: EPUBMetadataParser {

    /// Parses the metadata XML element to extract all publication metadata.
    ///
    /// The parsing process extracts the following Dublin Core elements:
    /// - **dc:title**: The title of the publication
    /// - **dc:creator**: The primary author(s) with optional role and file-as attributes
    /// - **dc:contributor**: Additional contributors (editors, translators, etc.)
    /// - **dc:identifier**: Unique identifier (ISBN, UUID, etc.)
    /// - **dc:language**: Primary language of the content
    /// - **dc:date**: Publication or creation date
    /// - **dc:publisher**: Name of the publisher
    /// - **dc:description**: Description or summary of the content
    /// - **dc:subject**: Subject keywords or categories
    /// - **dc:coverage**: Spatial or temporal coverage
    /// - **dc:format**: Physical or digital format
    /// - **dc:relation**: Related resources
    /// - **dc:rights**: Copyright and usage rights
    /// - **dc:source**: Source from which the publication is derived
    /// - **dc:type**: Nature or genre of the content
    ///
    /// Additionally, it processes `<meta>` elements for EPUB-specific metadata like cover references.
    ///
    /// - Parameter xmlElement: The metadata XML element from the package document.
    /// - Returns: An `EPUBMetadata` object populated with all extracted metadata.
    func parse(_ xmlElement: AEXMLElement) -> EPUBMetadata {
        var metadata = EPUBMetadata()
        
        // DUBLIN CORE CREATOR AND CONTRIBUTOR PARSING
        // These elements support OPF-specific attributes for enhanced metadata
        // The 'role' attribute uses MARC relator codes (aut=author, edt=editor, etc.)
        // The 'file-as' attribute provides sorting/indexing forms of names
        
        // Parse dc:contributor with optional OPF attributes
        // Contributors are secondary to creators (editors, translators, illustrators, etc.)
        metadata.contributor = EPUBCreator(
            name: xmlElement["dc:contributor"].value,
            role: xmlElement["dc:contributor"].attributes["opf:role"],
            fileAs: xmlElement["dc:contributor"].attributes["opf:file-as"]
        )
        
        // Parse dc:creator (primary author) with optional OPF attributes
        // Creator is the primary responsible party for the intellectual content
        // EPUB spec recommends using creator for authors and contributor for others
        metadata.creator = EPUBCreator(
            name: xmlElement["dc:creator"].value,
            role: xmlElement["dc:creator"].attributes["opf:role"],
            fileAs: xmlElement["dc:creator"].attributes["opf:file-as"]
        )
        
        // STANDARD DUBLIN CORE ELEMENTS
        // These follow the Dublin Core Metadata Element Set specification
        
        // Parse spatial or temporal coverage information (rarely used in EPUBs)
        metadata.coverage = xmlElement["dc:coverage"].value
        
        // Parse publication date - supports various ISO 8601 formats
        // Common formats: YYYY, YYYY-MM, YYYY-MM-DD, YYYY-MM-DDTHH:MM:SSZ
        metadata.date = xmlElement["dc:date"].value
        
        // Parse description or summary of the publication content
        metadata.description = xmlElement["dc:description"].value
        
        // Parse format information - typically "application/epub+zip" for EPUB files
        metadata.format = xmlElement["dc:format"].value
        
        // Parse unique identifier - can be ISBN, DOI, UUID, or other schemes
        // This should match the unique-identifier attribute in the package element
        metadata.identifier = xmlElement["dc:identifier"].value
        
        // Parse language code using RFC 3066/BCP 47 format (e.g., "en", "en-US", "fr-CA")
        // This is critical for accessibility and internationalization
        metadata.language = xmlElement["dc:language"].value
        
        // Parse publisher name - the entity responsible for making the publication available
        metadata.publisher = xmlElement["dc:publisher"].value
        
        // Parse relation to other resources (series information, editions, etc.)
        metadata.relation = xmlElement["dc:relation"].value
        
        // Parse copyright and rights information - important for legal compliance
        metadata.rights = xmlElement["dc:rights"].value
        
        // Parse source from which this publication is derived (for adaptations/translations)
        metadata.source = xmlElement["dc:source"].value
        
        // Parse subject keywords or categories for classification and discovery
        metadata.subject = xmlElement["dc:subject"].value
        
        // Parse title of the publication - the primary identifying name
        metadata.title = xmlElement["dc:title"].value
        
        // Parse type or genre of the content using DCMI Type Vocabulary
        metadata.type = xmlElement["dc:type"].value
        
        // EPUB-SPECIFIC METADATA PROCESSING
        // Process OPF-specific meta elements for additional publication information
        // The 'cover' meta element is particularly important for reading systems
        // that need to display cover images in library views
        xmlElement["meta"].all?
            .filter { $0.attributes["name"] == "cover" }
            .forEach { metadata.coverId = $0.attributes["content"] }
        
        return metadata
    }

}
