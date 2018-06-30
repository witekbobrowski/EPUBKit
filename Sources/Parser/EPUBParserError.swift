//
//  EPUBParserError
//  EPUBKit
//
//  Created by Witek on 14/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

enum EPUBParserError {
    case unzipFailed(reason: Error)
    case containerParseError
    case tableOfContentsMissing
}

// MARK: - LocalizedError
extension EPUBParserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unzipFailed:
            return "Error while trying to unzip the archive"
        case .containerParseError:
            return "Error with parsing container.xml"
        case .tableOfContentsMissing:
            return "Error with getting path for toc.ncx"
        }
    }

    var failureReason: String? {
        switch self {
        case .unzipFailed:
            return "Zip module was unable to unzip this archive"
        case .containerParseError:
            return "The path to container.xml may be wrong, or the file itself may be missing"
        case .tableOfContentsMissing:
            return "Table of contents ID was probably not mentioned in the spine"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unzipFailed:
            return "Make sure your archive is a proper .epub archive"
        case .containerParseError:
            return "Make sure the path to container.xml is correct"
        case .tableOfContentsMissing:
            return "Make sure to check if the '<spine>' contains the ID for TOC"
        }
    }
}
