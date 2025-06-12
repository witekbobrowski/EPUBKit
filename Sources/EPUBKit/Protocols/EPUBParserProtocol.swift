//
//  EPUBParserProtocol.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 27/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// The main protocol defining the complete interface for EPUB parsing.
///
/// EPUBParserProtocol combines parsing capabilities with delegation support,
/// providing a complete interface for EPUB document processing. It requires
/// conforming types to also implement EPUBParsable, ensuring all parsing
/// operations are available.
///
/// This protocol allows for different parser implementations while maintaining
/// a consistent public API. The protocol composition approach enables:
/// - Type safety through associated types
/// - Flexible implementation strategies
/// - Clear separation of concerns
///
/// Conforming types must implement:
/// - All EPUBParsable parsing methods
/// - Document-level parsing coordination
/// - Delegate notification management
///
/// Example implementation:
/// ```swift
/// class CustomEPUBParser: EPUBParserProtocol {
///     typealias XMLElement = MyXMLElement
///     weak var delegate: EPUBParserDelegate?
///     
///     func parse(documentAt path: URL) throws -> EPUBDocument {
///         // Implementation details...
///     }
/// }
/// ```
public protocol EPUBParserProtocol where Self: EPUBParsable {
    /// The delegate to receive parsing progress notifications.
    ///
    /// Set this property before calling parse() to monitor the parsing
    /// process and receive updates about each parsing stage. The delegate
    /// is held as a weak reference to prevent retain cycles.
    var delegate: EPUBParserDelegate? { get set }
    
    /// Parses a complete EPUB document from the specified URL.
    ///
    /// This is the main entry point for EPUB parsing. It coordinates
    /// the entire parsing process from archive extraction through
    /// component parsing, creating a fully-populated EPUBDocument.
    ///
    /// The method supports both:
    /// - Zipped EPUB files (.epub extension)
    /// - Pre-extracted EPUB directories
    ///
    /// Progress is reported through the delegate if one is set.
    ///
    /// - Parameter path: The file URL of the EPUB document or directory
    /// - Returns: A complete EPUBDocument with all parsed components
    /// - Throws: EPUBParserError for parsing failures, or other errors from underlying operations
    func parse(documentAt path: URL) throws -> EPUBDocument
}
