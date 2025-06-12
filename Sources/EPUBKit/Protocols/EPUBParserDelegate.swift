//
//  EPUBParserDelegate.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 27/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// A protocol for receiving notifications about EPUB parsing progress and events.
///
/// EPUBParserDelegate allows clients to monitor the parsing process in real-time,
/// receive progress updates, and handle parsing failures. This is particularly
/// useful for:
/// - Displaying progress indicators during parsing
/// - Implementing custom error handling
/// - Logging parsing events for debugging
/// - Loading cover images before full parsing completes
///
/// All delegate methods have default empty implementations, making them optional.
/// Implement only the methods you need for your specific use case.
///
/// Example usage:
/// ```swift
/// class MyParserDelegate: EPUBParserDelegate {
///     func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL) {
///         print("Started parsing: \(path.lastPathComponent)")
///     }
///     
///     func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error) {
///         print("Parsing failed: \(error.localizedDescription)")
///     }
/// }
/// ```
public protocol EPUBParserDelegate: AnyObject {
    /// Called when the parser begins processing an EPUB document.
    ///
    /// This is the first delegate method called and indicates that
    /// the parsing process has started for the specified document.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - path: The URL of the EPUB document being parsed
    func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL)
    
    /// Called after the EPUB archive has been successfully extracted.
    ///
    /// This method is only called for zipped EPUB files. If the input
    /// is already an extracted directory, this method is not invoked.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - directory: The URL of the directory containing extracted files
    func parser(_ parser: EPUBParser, didUnzipArchiveTo directory: URL)
    
    /// Called when the content directory has been located.
    ///
    /// The content directory is determined by parsing META-INF/container.xml
    /// and contains the actual publication files.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - directory: The URL of the content directory
    func parser(_ parser: EPUBParser, didLocateContentAt directory: URL)
    
    /// Called when the metadata parsing is complete.
    ///
    /// All Dublin Core and EPUB-specific metadata has been extracted
    /// from the package document.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - metadata: The parsed metadata containing publication information
    func parser(_ parser: EPUBParser, didFinishParsing metadata: EPUBMetadata)
    
    /// Called when the manifest parsing is complete.
    ///
    /// All publication resources have been cataloged and are available
    /// for access.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - manifest: The parsed manifest containing resource information
    func parser(_ parser: EPUBParser, didFinishParsing manifest: EPUBManifest)
    
    /// Called when the spine parsing is complete.
    ///
    /// The spine defines the reading order and has been successfully
    /// parsed from the package document.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - spine: The parsed spine containing reading order information
    func parser(_ parser: EPUBParser, didFinishParsing spine: EPUBSpine)
    
    /// Called when the table of contents parsing is complete.
    ///
    /// The hierarchical navigation structure has been successfully
    /// extracted from the NCX or navigation document.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - tableOfContents: The parsed navigation structure
    func parser(_ parser: EPUBParser, didFinishParsing tableOfContents: EPUBTableOfContents)
    
    /// Called when the entire parsing process completes successfully.
    ///
    /// This is the final delegate method called for successful parsing
    /// operations. The EPUBDocument is now fully constructed.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - path: The URL of the successfully parsed EPUB document
    func parser(_ parser: EPUBParser, didFinishParsingDocumentAt path: URL)
    
    /// Called when parsing fails at any stage.
    ///
    /// This method provides error information and allows for custom
    /// error handling. The parsing process is aborted when this occurs.
    ///
    /// - Parameters:
    ///   - parser: The parser instance performing the operation
    ///   - path: The URL of the EPUB document that failed to parse
    ///   - error: The error that caused parsing to fail
    func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error)
}

// MARK: - Default Implementations

/// Default empty implementations for all delegate methods.
/// This allows conforming types to implement only the methods they need.
public extension EPUBParserDelegate {
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didBeginParsingDocumentAt path: URL) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didUnzipArchiveTo directory: URL) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didLocateContentAt directory: URL) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFinishParsing metadata: EPUBMetadata) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFinishParsing manifest: EPUBManifest) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFinishParsing spine: EPUBSpine) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFinishParsing tableOfContents: EPUBTableOfContents) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFinishParsingDocumentAt path: URL) {}
    
    /// Default implementation does nothing.
    func parser(_ parser: EPUBParser, didFailParsingDocumentAt path: URL, with error: Error) {}
}
