//
//  EPUBDocumentTests.swift
//  EPUBKitTests
//
//  Created by Witek Bobrowski on 13/06/2021.
//  Ported to Swift Testing by Claude on 12/06/2025.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for EPUBDocument functionality and convenience initializers
@Suite("EPUBDocument Tests", .serialized)
struct EPUBDocumentTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Convenience Initializer Tests
    
    @Test("EPUBDocument with Alice in Wonderland (minimal metadata)")
    func epubDocumentWithAliceInWonderland() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        #expect(document.title == nil)
        #expect(document.author == nil)
        #expect(document.publisher == nil)
        #expect(document.cover == nil)
    }
    
    @Test("EPUBDocument with Geography of Bliss (complete metadata)")
    func epubDocumentWithGeographyOfBliss() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        #expect(document.title == "The Geography of Bliss: One Grump's Search for the Happiest Places in the World")
        #expect(document.author == "Eric Weiner")
        #expect(document.publisher == "Twelve")
        #expect(document.cover != nil)
    }
    
    @Test("EPUBDocument with Metamorphosis (author validation)")
    func epubDocumentWithMetamorphosis() {
        let url = library.path(for: .theMetamorphosis)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        #expect(document.title == "Metamorphosis")
        #expect(document.author == "Franz Kafka")
        #expect(document.publisher == "PressBooks.com")
        #expect(document.cover != nil)
    }
    
    @Test("EPUBDocument with Problems of Philosophy (classic text)")
    func epubDocumentWithProblemsOfPhilosophy() {
        let url = library.path(for: .theProblemsofPhilosophy)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        #expect(document.title == "The Problems of Philosophy")
        #expect(document.author == "Bertrand Russell")
        #expect(document.publisher == "PresssBooks.com")
        #expect(document.cover != nil)
    }
    
    // MARK: - Parameterized Tests
    
    @Test("Parse valid EPUB documents", arguments: [
        EPUBFile.alicesAdventuresinWonderland,
        EPUBFile.theGeographyofBliss,
        EPUBFile.theMetamorphosis,
        EPUBFile.theProblemsofPhilosophy
    ])
    func parseValidEPUBDocuments(file: EPUBFile) {
        let url = library.path(for: file)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly for \(file)")
            return
        }
        
        // Basic structure validation - these properties are non-optional
        // so we check for meaningful content instead
        #expect(!document.manifest.items.isEmpty)
        #expect(!document.spine.items.isEmpty)
        #expect(!document.tableOfContents.label.isEmpty)
    }
    
    // MARK: - Document Structure Tests
    
    @Test("Validate document structure components")
    func validateDocumentStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Directory structure
        #expect(document.directory.hasDirectoryPath)
        #expect(document.contentDirectory.hasDirectoryPath)
        
        // Component structure
        #expect(!document.manifest.items.isEmpty)
        #expect(!document.spine.items.isEmpty)
        #expect(!document.tableOfContents.label.isEmpty)
    }
    
    @Test("Validate cover image access")
    func validateCoverImageAccess() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        if let cover = document.cover {
            #expect(!cover.absoluteString.isEmpty)
            #expect(FileManager.default.fileExists(atPath: cover.path))
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Convenience initializer failure handling")
    func convenienceInitializerFailure() {
        let brokenFiles: [EPUBFile] = [
            .alicesAdventuresinWonderlandBrokenArchive,
            .theGeographyofBlissBrokenContainer,
            .theMetamorphosisBrokenToc,
            .theProblemsofPhilosophyBrokenContent
        ]
        
        for file in brokenFiles {
            let url = library.path(for: file)
            let document = EPUBDocument(url: url)
            #expect(document == nil, "Document creation should fail for \(file)")
        }
        
        // Nonexistent file
        let nonexistentURL = URL(fileURLWithPath: "/nonexistent/file.epub")
        let document = EPUBDocument(url: nonexistentURL)
        #expect(document == nil, "Document creation should fail for nonexistent file")
    }
    
    // MARK: - Direct Initializer Tests
    
    @Test("Direct initializer")
    func directInitializer() {
        let url = library.path(for: .theGeographyofBliss)
        let parser = EPUBParser()
        
        do {
            let document = try parser.parse(documentAt: url)
            let directDocument = EPUBDocument(
                directory: document.directory,
                contentDirectory: document.contentDirectory,
                metadata: document.metadata,
                manifest: document.manifest,
                spine: document.spine,
                tableOfContents: document.tableOfContents
            )
            
            #expect(directDocument.title == document.title)
            #expect(directDocument.author == document.author)
            #expect(directDocument.publisher == document.publisher)
        } catch {
            Issue.record("Parser should work correctly: \(error)")
        }
    }
    
    @Test("Document with minimal metadata")
    func documentWithMinimalMetadata() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Should handle nil values gracefully
        #expect(document.title == nil)
        #expect(document.author == nil) 
        #expect(document.publisher == nil)
        
        // But structure should still be valid - these are non-optional
        // Check that they have content even if title/author are nil
        #expect(!document.manifest.items.isEmpty)
        #expect(!document.spine.items.isEmpty)
    }
}
