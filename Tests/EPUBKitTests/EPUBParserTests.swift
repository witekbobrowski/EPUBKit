//
//  EPUBParserTests.swift
//  EPUBKitTests
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for EPUBParser core functionality
@Suite("EPUBParser Tests", .serialized)
struct EPUBParserTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Basic Parsing Tests
    
    @Test("Parse valid EPUB files")
    func parseValidEPUBFiles() {
        let parser = EPUBParser()
        let validFiles: [EPUBFile] = [
            .alicesAdventuresinWonderland,
            .theGeographyofBliss,
            .theMetamorphosis,
            .theProblemsofPhilosophy
        ]
        
        for file in validFiles {
            let url = library.path(for: file)
            
            do {
                let document = try parser.parse(documentAt: url)
                // Document components are always present (non-optional)
                #expect(!document.manifest.items.isEmpty)
                #expect(!document.spine.items.isEmpty)
            } catch {
                Issue.record("Parsing failed for \(file): \(error)")
            }
        }
    }
    
    @Test("Parser works without delegate")
    func parserWorksWithoutDelegate() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        parser.delegate = nil
        #expect(parser.delegate == nil)
        
        do {
            let document = try parser.parse(documentAt: url)
            #expect(document.title != nil)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    // MARK: - Component Extraction Tests
    
    @Test("Parser extracts metadata correctly")
    func parserExtractsMetadataCorrectly() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            let metadata = document.metadata
            
            #expect(metadata.title == "The Geography of Bliss: One Grump's Search for the Happiest Places in the World")
            #expect(metadata.creator?.name == "Eric Weiner")
            #expect(metadata.publisher == "Twelve")
            #expect(metadata.identifier != nil)
            #expect(metadata.language != nil)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    @Test("Parser extracts manifest correctly")
    func parserExtractsManifestCorrectly() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            let manifest = document.manifest
            
            #expect(!manifest.items.isEmpty, "Manifest should contain items")
            
            // Check for typical EPUB components
            let hasXHTMLContent = manifest.items.values.contains { item in
                item.mediaType == .xHTML
            }
            #expect(hasXHTMLContent, "Should have XHTML content documents")
            
            // Validate manifest item structure
            for (id, item) in manifest.items {
                #expect(item.id == id, "Item ID should match dictionary key")
                #expect(!item.path.isEmpty, "Item path should not be empty")
                #expect(item.mediaType != .unknown, "Media type should be recognized")
            }
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    @Test("Parser extracts spine correctly")
    func parserExtractsSpineCorrectly() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            let spine = document.spine
            
            #expect(!spine.items.isEmpty, "Spine should contain items")
            #expect(spine.pageProgressionDirection != nil, "Should have page progression direction")
            
            // Validate spine items reference manifest
            for spineItem in spine.items {
                #expect(document.manifest.items[spineItem.idref] != nil,
                       "Spine item should reference valid manifest item")
            }
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    @Test("Parser extracts table of contents correctly")
    func parserExtractsTOCCorrectly() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            let toc = document.tableOfContents
            
            #expect(!toc.label.isEmpty, "TOC should have a label")
            #expect(!toc.id.isEmpty, "TOC should have an ID")
            
            // Validate hierarchical structure if present
            if let subTable = toc.subTable, !subTable.isEmpty {
                for subTOC in subTable {
                    #expect(!subTOC.label.isEmpty, "Sub-TOC should have a label")
                    #expect(!subTOC.id.isEmpty, "Sub-TOC should have an ID")
                }
            }
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    // MARK: - Archive Processing Tests
    
    @Test("Parser handles ZIP extraction")
    func parserHandlesZIPExtraction() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            
            // Should extract to a temporary directory
            #expect(document.directory.hasDirectoryPath)
            #expect(document.contentDirectory.hasDirectoryPath)
            
            // Content directory should be within extracted directory
            #expect(document.contentDirectory.path.hasPrefix(document.directory.path))
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    @Test("Parser supports pre-extracted directories")
    func parserSupportsPreExtractedDirectories() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let document = try parser.parse(documentAt: url)
            let extractedDirectory = document.directory
            
            // Now parse the extracted directory
            let documentFromDirectory = try parser.parse(documentAt: extractedDirectory)
            
            // Should produce equivalent results
            #expect(documentFromDirectory.title == document.title)
            #expect(documentFromDirectory.author == document.author)
            #expect(documentFromDirectory.publisher == document.publisher)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
    }
    
    
    // MARK: - Memory Management Tests
    
    @Test("Parser properly manages delegate lifecycle")
    func parserProperlyManagesDelegateLifecycle() {
        let parser = EPUBParser()
        let url = library.path(for: .alicesAdventuresinWonderland)
        
        do {
            let delegate = MockedEPUBParserDelegate()
            parser.delegate = delegate
            #expect(parser.delegate != nil)
            
            do {
                _ = try parser.parse(documentAt: url)
            } catch {
                Issue.record("Parsing should not fail: \(error)")
            }
        } // delegate goes out of scope
        
        // Parser should not retain delegate
        #expect(parser.delegate == nil, "Delegate should be released when out of scope")
    }
}
