//
//  EPUBArchiveService.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import Zip

/// Protocol defining the interface for EPUB archive extraction operations.
///
/// This protocol abstracts the archive extraction functionality, allowing for
/// different implementations of ZIP extraction mechanisms.
protocol EPUBArchiveService {
    /// Extracts the contents of an EPUB archive to a temporary directory.
    ///
    /// - Parameter url: The file URL of the EPUB archive to extract.
    /// - Returns: The URL of the directory containing the extracted contents.
    /// - Throws: `EPUBParserError.unzipFailed` if extraction fails.
    func unarchive(archive url: URL) throws -> URL
}

/// Concrete implementation of `EPUBArchiveService` using the Zip library.
///
/// This service handles the extraction of EPUB files, which are essentially ZIP archives
/// containing structured XHTML content, metadata, and resources. According to the EPUB
/// specification (Section 3.3), an EPUB file must be a ZIP-based OCF (Open Container Format)
/// archive.
///
/// The service uses the Zip library to handle the extraction process and ensures that
/// files with the `.epub` extension are recognized as valid ZIP archives.
class EPUBArchiveServiceImplementation: EPUBArchiveService {

    /// Initializes the archive service and registers the EPUB file extension.
    ///
    /// This ensures that the Zip library recognizes `.epub` files as valid ZIP archives
    /// for extraction operations.
    init() {
        // Register .epub as a custom file extension for the Zip library
        // This is necessary because EPUB files don't have the standard .zip extension
        Zip.addCustomFileExtension("epub")
    }

    /// Extracts the contents of an EPUB archive to a temporary directory.
    ///
    /// The extraction process follows these steps:
    /// 1. Validates that the file at the given URL exists
    /// 2. Uses Zip.quickUnzipFile to extract all contents to a temporary directory
    /// 3. Returns the URL of the extraction directory
    ///
    /// The temporary directory is managed by the system and will be cleaned up
    /// automatically when no longer needed.
    ///
    /// - Parameter url: The file URL of the EPUB archive to extract.
    /// - Returns: The URL of the temporary directory containing the extracted contents.
    /// - Throws: `EPUBParserError.unzipFailed` wrapping the underlying extraction error.
    func unarchive(archive url: URL) throws -> URL {
        var destination: URL
        do {
            // Use Zip library's quick extraction method
            // This extracts all contents to a system-managed temporary directory
            destination = try Zip.quickUnzipFile(url)
        } catch {
            // Wrap the underlying error in our domain-specific error type
            // This provides better context about what operation failed
            throw EPUBParserError.unzipFailed(reason: error)
        }
        return destination
    }

}
