//
//  EPUBMediaType.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents the media types (MIME types) supported in EPUB publications.
///
/// EPUB 3 defines Core Media Types that must be supported by all reading systems,
/// as well as additional media types that may be supported. This enum covers
/// the most common media types found in EPUB publications.
///
/// Core Media Types include:
/// - XHTML Content Documents
/// - SVG Content Documents  
/// - CSS Style Sheets
/// - PNG, JPEG, GIF images
/// - TrueType and OpenType fonts
/// - WOFF and WOFF2 fonts
/// - MP3 and MP4 audio
/// - JavaScript
/// - NCX (for EPUB 2 compatibility)
///
/// Reference: EPUB 3.3 Core Media Types
/// (https://www.w3.org/TR/epub-33/#sec-core-media-types)
public enum EPUBMediaType: String {
    // MARK: - Image Types
    /// GIF image format (Core Media Type)
    case gif = "image/gif"
    /// JPEG image format (Core Media Type)
    case jpeg = "image/jpeg"
    /// PNG image format (Core Media Type)
    case png = "image/png"
    /// SVG vector graphics (Core Media Type)
    case svg = "image/svg+xml"
    
    // MARK: - Document Types
    /// XHTML content document (Core Media Type)
    /// The primary format for EPUB content
    case xHTML = "application/xhtml+xml"
    /// NCX navigation document (EPUB 2 legacy format)
    /// Still supported for backwards compatibility
    case opf2 = "application/x-dtbncx+xml"
    
    // MARK: - Script Types
    /// JavaScript code (Core Media Type)
    /// Using the RFC 4329 MIME type
    case rfc4329 = "application/javascript"
    
    // MARK: - Font Types
    /// OpenType font format (Core Media Type)
    /// Using the SFNT container format MIME type
    case openType = "application/font-sfnt"
    /// Web Open Font Format (Core Media Type)
    case woff = "application/font-woff"
    /// Web Open Font Format 2 (Core Media Type)
    case woff2 = "font/woff2"
    
    // MARK: - Media Overlay Types
    /// SMIL Media Overlays for synchronized audio/text
    case mediaOverlays = "application/smil+xml"
    /// Pronunciation Lexicon Specification
    case pls = "application/pls+xml"
    
    // MARK: - Audio Types
    /// MP3 audio format (Core Media Type)
    case mp3 = "audio/mpeg"
    /// MP4 audio container (Core Media Type)
    case mp4 = "audio/mp4"
    
    // MARK: - Style Types
    /// CSS stylesheets (Core Media Type)
    case css = "text/css"
    
    // MARK: - Fallback Type
    /// Unknown or unsupported media type
    case unknown
}
