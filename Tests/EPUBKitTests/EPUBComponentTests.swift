//
//  EPUBComponentTests.swift
//  EPUBKitTests
//
//  Created by Claude on 12/06/2025.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for individual EPUB component parsing and services
@Suite("EPUB Component Tests", .serialized)
struct EPUBComponentTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Archive Service Tests
    
    @Test("Archive service extracts valid EPUB")
    func archiveServiceExtractsValidEPUB() {
        let archiveService = EPUBArchiveServiceImplementation()
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let extractedDir = try archiveService.unarchive(archive: url)
            #expect(extractedDir.hasDirectoryPath, "Should extract to directory")
            #expect(FileManager.default.fileExists(atPath: extractedDir.path), "Extracted directory should exist")
            
            // Check for expected EPUB structure
            let metaInfPath = extractedDir.appendingPathComponent("META-INF").path
            #expect(FileManager.default.fileExists(atPath: metaInfPath), "Should have META-INF directory")
        } catch {
            Issue.record("Archive extraction should not fail: \(error)")
        }
    }
    
    @Test("Archive service handles extraction errors")
    func archiveServiceHandlesExtractionErrors() {
        let archiveService = EPUBArchiveServiceImplementation()
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        
        do {
            _ = try archiveService.unarchive(archive: url)
            Issue.record("Expected archive extraction to fail")
        } catch let error as EPUBParserError {
            guard case .unzipFailed = error else {
                Issue.record("Expected unzipFailed error")
                return
            }
        } catch {
            Issue.record("Expected EPUBParserError, got \(error)")
        }
    }
    
    // MARK: - Content Service Tests
    
    @Test("Content service locates package document")
    func contentServiceLocatesPackageDocument() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            // Should provide access to package components
            #expect(contentService.contentDirectory.hasDirectoryPath)
            #expect(FileManager.default.fileExists(atPath: contentService.contentDirectory.path))
            
            // Should parse package document elements
            let metadata = contentService.metadata
            let manifest = contentService.manifest  
            let spine = contentService.spine
            
            #expect(metadata.name == "metadata", "Should locate metadata element")
            #expect(manifest.name == "manifest", "Should locate manifest element")
            #expect(spine.name == "spine", "Should locate spine element")
        } catch {
            Issue.record("Content service should work: \(error)")
        }
    }
    
    @Test("Content service handles missing container")
    func contentServiceHandlesMissingContainer() {
        let url = library.path(for: .theGeographyofBlissBrokenContainer)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            
            _ = try EPUBContentServiceImplementation(extractedDir)
            Issue.record("Expected content service to fail")
        } catch let error as EPUBParserError {
            guard case .containerMissing = error else {
                Issue.record("Expected containerMissing error")
                return
            }
        } catch {
            Issue.record("Expected EPUBParserError, got \(error)")
        }
    }
    
    // MARK: - Metadata Parser Tests
    
    @Test("Metadata parser extracts Dublin Core elements")
    func metadataParserExtractsDublinCoreElements() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBMetadataParserImplementation()
            let metadata = parser.parse(contentService.metadata)
            
            #expect(metadata.title == "The Geography of Bliss: One Grump's Search for the Happiest Places in the World")
            #expect(metadata.creator?.name == "Eric Weiner")
            #expect(metadata.publisher == "Twelve")
            #expect(metadata.identifier != nil)
            #expect(metadata.language != nil)
        } catch {
            Issue.record("Metadata parsing should work: \(error)")
        }
    }
    
    @Test("Metadata parser handles creator attributes")
    func metadataParserHandlesCreatorAttributes() {
        let url = library.path(for: .theMetamorphosis)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBMetadataParserImplementation()
            let metadata = parser.parse(contentService.metadata)
            
            #expect(metadata.creator?.name == "Franz Kafka")
            
            // Test role and file-as attributes if present
            if let creator = metadata.creator {
                if let role = creator.role {
                    #expect(!role.isEmpty, "Role should not be empty if present")
                }
                if let fileAs = creator.fileAs {
                    #expect(!fileAs.isEmpty, "File-as should not be empty if present")
                }
            }
        } catch {
            Issue.record("Metadata parsing should work: \(error)")
        }
    }
    
    @Test("Metadata parser handles minimal metadata")
    func metadataParserHandlesMinimalMetadata() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBMetadataParserImplementation()
            let metadata = parser.parse(contentService.metadata)
            
            // Should handle missing elements gracefully
            #expect(metadata.title == nil)
            #expect(metadata.creator?.name == nil)
            #expect(metadata.publisher == nil)
            
            // Should still create valid structure even with minimal metadata
            // Alice in Wonderland test file is intentionally minimal
        } catch {
            Issue.record("Metadata parsing should work: \(error)")
        }
    }
    
    // MARK: - Manifest Parser Tests
    
    @Test("Manifest parser extracts all items")
    func manifestParserExtractsAllItems() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBManifestParserImplementation()
            let manifest = parser.parse(contentService.manifest)
            
            #expect(!manifest.items.isEmpty, "Should extract manifest items")
            
            // Validate item structure
            for (id, item) in manifest.items {
                #expect(item.id == id, "Item ID should match key")
                #expect(!item.path.isEmpty, "Item path should not be empty")
                #expect(item.mediaType != .unknown, "Should recognize media types")
            }
        } catch {
            Issue.record("Manifest parsing should work: \(error)")
        }
    }
    
    @Test("Manifest parser handles media types correctly")
    func manifestParserHandlesMediaTypesCorrectly() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBManifestParserImplementation()
            let manifest = parser.parse(contentService.manifest)
            
            let mediaTypes = manifest.items.values.map { $0.mediaType }
            
            // Should have content documents
            #expect(mediaTypes.contains(.xHTML), "Should have XHTML content")
            
            // Should have stylesheets
            #expect(mediaTypes.contains(.css), "Should have CSS files")
            
            // Should recognize common image types
            let hasImages = mediaTypes.contains { [.jpeg, .png, .gif, .svg].contains($0) }
            #expect(hasImages, "Should have recognizable image types")
        } catch {
            Issue.record("Manifest parsing should work: \(error)")
        }
    }
    
    // MARK: - Spine Parser Tests
    
    @Test("Spine parser extracts reading order")
    func spineParserExtractsReadingOrder() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBSpineParserImplementation()
            let spine = parser.parse(contentService.spine)
            
            #expect(!spine.items.isEmpty, "Should extract spine items")
            #expect(spine.pageProgressionDirection != nil, "Should have page progression")
            
            // Validate spine items
            for item in spine.items {
                #expect(!item.idref.isEmpty, "Spine item should reference manifest")
            }
        } catch {
            Issue.record("Spine parsing should work: \(error)")
        }
    }
    
    @Test("Spine parser handles page progression direction")
    func spineParserHandlesPageProgressionDirection() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            let parser = EPUBSpineParserImplementation()
            let spine = parser.parse(contentService.spine)
            
            if let direction = spine.pageProgressionDirection {
                let validDirections: [EPUBPageProgressionDirection] = [.leftToRight, .rightToLeft]
                #expect(validDirections.contains(direction), "Should parse valid direction")
            }
        } catch {
            Issue.record("Spine parsing should work: \(error)")
        }
    }
    
    // MARK: - Table of Contents Parser Tests
    
    @Test("TOC parser extracts navigation structure")
    func tocParserExtractsNavigationStructure() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            // Get TOC file name from spine
            let spineParser = EPUBSpineParserImplementation()
            let spine = spineParser.parse(contentService.spine)
            
            guard let tocId = spine.toc else {
                Issue.record("Spine should reference TOC")
                return
            }
            
            let manifestParser = EPUBManifestParserImplementation()
            let manifest = manifestParser.parse(contentService.manifest)
            
            guard let tocItem = manifest.items[tocId] else {
                Issue.record("TOC should exist in manifest")
                return
            }
            
            let tocElement = try contentService.tableOfContents(tocItem.path)
            let tocParser = EPUBTableOfContentsParserImplementation()
            let toc = tocParser.parse(tocElement)
            
            #expect(!toc.label.isEmpty, "TOC should have label")
            #expect(!toc.id.isEmpty, "TOC should have ID")
        } catch {
            Issue.record("TOC parsing should work: \(error)")
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("All parsers work together correctly")
    func allParsersWorkTogetherCorrectly() {
        let url = library.path(for: .theGeographyofBliss)
        
        do {
            // Extract archive
            let archiveService = EPUBArchiveServiceImplementation()
            let extractedDir = try archiveService.unarchive(archive: url)
            
            // Locate content
            let contentService = try EPUBContentServiceImplementation(extractedDir)
            
            // Parse all components
            let metadataParser = EPUBMetadataParserImplementation()
            let manifestParser = EPUBManifestParserImplementation()
            let spineParser = EPUBSpineParserImplementation()
            let tocParser = EPUBTableOfContentsParserImplementation()
            
            let metadata = metadataParser.parse(contentService.metadata)
            let manifest = manifestParser.parse(contentService.manifest)
            let spine = spineParser.parse(contentService.spine)
            
            // Validate cross-references
            for spineItem in spine.items {
                #expect(manifest.items[spineItem.idref] != nil,
                       "Spine should reference manifest items")
            }
            
            if let tocId = spine.toc {
                #expect(manifest.items[tocId] != nil,
                       "TOC reference should exist in manifest")
                
                if let tocItem = manifest.items[tocId] {
                    let tocElement = try contentService.tableOfContents(tocItem.path)
                    let toc = tocParser.parse(tocElement)
                    #expect(!toc.label.isEmpty, "TOC should be parsed correctly")
                }
            }
            
            if let coverId = metadata.coverId {
                #expect(manifest.items[coverId] != nil,
                       "Cover reference should exist in manifest")
            }
        } catch {
            Issue.record("Integration test should work: \(error)")
        }
    }
}
