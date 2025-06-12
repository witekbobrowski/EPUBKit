//
//  EPUBParserError
//  EPUBKit
//
//  Created by Witek on 14/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Errors that can occur during EPUB parsing.
///
/// These errors represent specific failure points in the EPUB parsing process,
/// from archive extraction through component parsing. Each error provides
/// detailed information to help diagnose and resolve parsing issues.
public enum EPUBParserError {
    /// Failed to extract the EPUB archive.
    /// 
    /// This can occur when:
    /// - The file is not a valid ZIP archive
    /// - The archive is corrupted
    /// - Insufficient permissions to create temporary directory
    /// 
    /// - Parameter reason: The underlying error from the unzip operation
    case unzipFailed(reason: Error)
    
    /// The META-INF/container.xml file is missing.
    /// 
    /// This file is required by the EPUB specification to locate
    /// the package document. Its absence indicates an invalid EPUB.
    case containerMissing
    
    /// The container.xml doesn't specify a content.opf path.
    /// 
    /// The rootfile element in container.xml must include a
    /// full-path attribute pointing to the package document.
    case contentPathMissing
    
    /// The table of contents file referenced in spine cannot be found.
    /// 
    /// The spine's toc attribute references a manifest item that
    /// either doesn't exist or points to a missing file.
    case tableOfContentsMissing
}

// MARK: - LocalizedError
extension EPUBParserError: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .unzipFailed:
            return "Error while trying to unzip the archive"
        case .containerMissing:
            return "Error while locating container.xml"
        case .contentPathMissing:
            return "Error while locating path to content"
        case .tableOfContentsMissing:
            return "Error with getting path for toc.ncx"
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case .unzipFailed:
            return "Zip module was unable to unzip this archive"
        case .containerMissing:
            return "The container.xml may be missing"
        case .contentPathMissing:
            return "Path to content is not mentioned in container.xml"
        case .tableOfContentsMissing:
            return "Table of contents ID was probably not mentioned in the spine"
        }
    }

    /// A localized recovery suggestion to help resolve the error.
    public var recoverySuggestion: String? {
        switch self {
        case .unzipFailed:
            return "Make sure your archive is a valid .epub archive"
        case .containerMissing:
            return "Make sure the path to container.xml is correct, and the file itself is present."
        case .contentPathMissing:
            return "Path to content may be in different place in container.xml then normally."
        case .tableOfContentsMissing:
            return "Make sure to check if the '<spine>' contains the ID for TOC"
        }
    }
}
