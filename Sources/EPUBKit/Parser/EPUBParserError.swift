//
//  EPUBParserError
//  EPUBKit
//
//  Created by Witek on 14/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public enum EPUBParserError {
    case unzipFailed(reason: Error)
    case containerMissing
    case contentPathMissing
    case tableOfContentsMissing
}

// MARK: - LocalizedError
extension EPUBParserError: LocalizedError {
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
