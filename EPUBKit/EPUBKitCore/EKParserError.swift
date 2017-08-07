//
//  EKParserError.swift
//  EPUBKit
//
//  Created by Witek on 14/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

enum EKParserError: LocalizedError {
    
    case unZipError
    case containerParseError
    case noPathForTableOfContents
    case noIdForTableOfContents
    
    var errorDescription: String? {
        switch self {
        case .unZipError:
            return "Error while trying to unzip the archive"
        case .containerParseError:
            return "Error with parsing container.xml"
        case .noPathForTableOfContents:
            return "Error with getting ID for toc.ncx"
        case .noIdForTableOfContents:
            return "Error with getting path for toc.ncx"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .unZipError:
            return "Zip module was unable to unzip this archive"
        case .containerParseError:
            return "The path to container.xml may be wrong, or the file itself may be missing"
        case .noPathForTableOfContents:
            return "Path to table of contents was not found in the manifest!"
        case .noIdForTableOfContents:
            return "Table of contents ID was probably not mentioned in the spine"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .unZipError:
            return "Make sure your archive is a proper .epub archive"
        case .containerParseError:
            return "Make sure the path to container.xml is correct"
        case .noPathForTableOfContents:
            return "Path to table of contents was not found in the manifest!"
        case .noIdForTableOfContents:
            return "Make sure to check if the '<spine>' contains the ID for TOC"
        }
    }
    
}
