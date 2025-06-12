//
//  EPUBModelValidationTests.swift
//  EPUBKitTests
//
//  Created by Claude on 12/06/2025.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for EPUB model validation and EPUB specification compliance
@Suite("EPUB Model Validation Tests", .serialized)
struct EPUBModelValidationTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Metadata Validation
    
    @Test("Validate metadata structure and Dublin Core elements")
    func validateMetadataStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let metadata = document.metadata
        
        // Required Dublin Core elements (EPUB spec)
        #expect(metadata.title != nil, "dc:title should be present")
        #expect(metadata.identifier != nil, "dc:identifier should be present") 
        #expect(metadata.language != nil, "dc:language should be present")
        
        // Optional but common elements
        if let creator = metadata.creator {
            #expect(!creator.name!.isEmpty, "Creator name should not be empty")
            // Test creator attributes
            if let role = creator.role {
                #expect(!role.isEmpty, "Creator role should not be empty if present")
            }
            if let fileAs = creator.fileAs {
                #expect(!fileAs.isEmpty, "File-as should not be empty if present")
            }
        }
        
        // Publisher validation
        if let publisher = metadata.publisher {
            #expect(!publisher.isEmpty, "Publisher should not be empty if present")
        }
        
        // Cover validation
        if let coverId = metadata.coverId {
            #expect(!coverId.isEmpty, "Cover ID should not be empty if present")
        }
    }
    
    @Test("Validate metadata with minimal content")
    func validateMetadataWithMinimalContent() {
        let url = library.path(for: .alicesAdventuresinWonderland)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Alice has minimal metadata, but should still be valid
        let metadata = document.metadata
        
        // Should handle nil values gracefully
        if let title = metadata.title {
            #expect(!title.isEmpty, "Title should not be empty if present")
        }
        if let creator = metadata.creator, let name = creator.name {
            #expect(!name.isEmpty, "Creator name should not be empty if present")
        }
        if let publisher = metadata.publisher {
            #expect(!publisher.isEmpty, "Publisher should not be empty if present")
        }
    }
    
    // MARK: - Manifest Validation
    
    @Test("Validate manifest structure and items")
    func validateManifestStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let manifest = document.manifest
        
        // Manifest should contain items
        #expect(!manifest.items.isEmpty, "Manifest should contain items")
        
        // Validate each manifest item
        for (id, item) in manifest.items {
            // Item validation
            #expect(item.id == id, "Item ID should match dictionary key")
            #expect(!item.id.isEmpty, "Item ID should not be empty")
            #expect(!item.path.isEmpty, "Item path should not be empty")
            #expect(item.mediaType != .unknown, "Media type should be recognized")
            
            // Path validation
            #expect(!item.path.hasPrefix("/"), "Item path should be relative")
            #expect(!item.path.contains(".."), "Item path should not contain parent references")
            
            // Properties validation (if present)
            if let properties = item.property {
                #expect(!properties.isEmpty, "Properties should not be empty if present")
            }
        }
    }
    
    @Test("Validate manifest media types")
    func validateManifestMediaTypes() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let manifest = document.manifest
        let mediaTypes = manifest.items.values.map { $0.mediaType }
        
        // Should have content documents
        let hasContentDocuments = mediaTypes.contains(.xHTML)
        #expect(hasContentDocuments, "Should have XHTML content documents")
        
        // Should have stylesheets (common)
        let hasCSS = mediaTypes.contains(.css)
        #expect(hasCSS, "Should typically have CSS stylesheets")
        
        // Validate that we don't have too many unknown types
        let unknownCount = mediaTypes.filter { $0 == .unknown }.count
        let totalCount = mediaTypes.count
        let unknownRatio = Double(unknownCount) / Double(totalCount)
        #expect(unknownRatio < 0.5, "Should recognize most media types")
    }
    
    // MARK: - Spine Validation
    
    @Test("Validate spine structure and reading order")
    func validateSpineStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let spine = document.spine
        let manifest = document.manifest
        
        // Spine should contain items
        #expect(!spine.items.isEmpty, "Spine should contain items")
        
        // Page progression direction should be valid
        if let direction = spine.pageProgressionDirection {
            let validDirections: [EPUBPageProgressionDirection] = [.leftToRight, .rightToLeft]
            #expect(validDirections.contains(direction), "Page progression direction should be valid")
        }
        
        // Validate spine items
        for spineItem in spine.items {
            #expect(!spineItem.idref.isEmpty, "Spine item idref should not be empty")
            
            // Spine item should reference valid manifest item
            let manifestItem = manifest.items[spineItem.idref]
            #expect(manifestItem != nil, "Spine item should reference valid manifest item")
            
            // Referenced item should typically be a content document
            if let item = manifestItem {
                let isContentDocument = item.mediaType == .xHTML || item.mediaType == .svg
                #expect(isContentDocument, "Spine should typically reference content documents")
            }
        }
    }
    
    @Test("Validate spine references")
    func validateSpineReferences() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let spine = document.spine
        let manifest = document.manifest
        
        // All spine items should reference manifest items
        let spineRefs = Set(spine.items.map { $0.idref })
        let manifestIds = Set(manifest.items.keys)
        
        #expect(spineRefs.isSubset(of: manifestIds), "All spine references should exist in manifest")
        
        // TOC reference should be valid (if present)
        if let toc = spine.toc {
            #expect(manifest.items[toc] != nil, "TOC reference should exist in manifest")
            
            if let tocItem = manifest.items[toc] {
                #expect(tocItem.mediaType == .opf2, "TOC should reference NCX file")
            }
        }
    }
    
    // MARK: - Table of Contents Validation
    
    @Test("Validate table of contents structure")
    func validateTableOfContentsStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        let toc = document.tableOfContents
        
        // TOC should have basic structure
        #expect(!toc.label.isEmpty, "TOC label should not be empty")
        #expect(!toc.id.isEmpty, "TOC ID should not be empty")
        
        // Validate hierarchical structure
        validateTOCHierarchy(toc)
    }
    
    private func validateTOCHierarchy(_ toc: EPUBTableOfContents) {
        // Current level validation
        #expect(!toc.label.isEmpty, "TOC label should not be empty")
        #expect(!toc.id.isEmpty, "TOC ID should not be empty")
        
        // Content reference validation (if present)
        if let item = toc.item {
            #expect(!item.isEmpty, "TOC item reference should not be empty")
        }
        
        // Recursive validation of sub-levels
        if let subTable = toc.subTable {
            for subTOC in subTable {
                validateTOCHierarchy(subTOC)
            }
        }
    }
    
    // MARK: - Cross-Component Validation
    
    @Test("Validate cross-component references")
    func validateCrossComponentReferences() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Cover reference validation
        if let coverId = document.metadata.coverId {
            let coverItem = document.manifest.items[coverId]
            #expect(coverItem != nil, "Cover ID should reference valid manifest item")
            
            if let item = coverItem {
                let isImageType = [.gif, .jpeg, .png, .svg].contains(item.mediaType)
                #expect(isImageType, "Cover should reference an image file")
            }
        }
        
        // Spine-manifest consistency
        for spineItem in document.spine.items {
            let manifestItem = document.manifest.items[spineItem.idref]
            #expect(manifestItem != nil, "Spine items should reference manifest items")
        }
        
        // TOC-manifest consistency
        if let tocId = document.spine.toc {
            let tocItem = document.manifest.items[tocId]
            #expect(tocItem != nil, "TOC reference should exist in manifest")
        }
    }
    
    // MARK: - Directory Structure Validation
    
    @Test("Validate directory structure")
    func validateDirectoryStructure() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Directory paths should be valid
        #expect(document.directory.hasDirectoryPath, "Directory should be a directory path")
        #expect(document.contentDirectory.hasDirectoryPath, "Content directory should be a directory path")
        
        // Content directory should be within or equal to main directory
        let contentPath = document.contentDirectory.path
        let mainPath = document.directory.path
        #expect(contentPath.hasPrefix(mainPath), "Content directory should be within main directory")
        
        // Directories should exist (at least temporarily)
        #expect(FileManager.default.fileExists(atPath: mainPath), "Main directory should exist")
        #expect(FileManager.default.fileExists(atPath: contentPath), "Content directory should exist")
    }
    
    // MARK: - EPUB Specification Compliance
    
    @Test("Validate EPUB specification compliance")
    func validateEPUBSpecificationCompliance() {
        let url = library.path(for: .theGeographyofBliss)
        guard let document = EPUBDocument(url: url) else {
            Issue.record("Document should be parsed correctly")
            return
        }
        
        // Required metadata elements (EPUB 3 spec)
        let metadata = document.metadata
        #expect(metadata.identifier != nil, "EPUB requires dc:identifier")
        #expect(metadata.title != nil, "EPUB requires dc:title")
        #expect(metadata.language != nil, "EPUB requires dc:language")
        
        // Manifest requirements
        #expect(!document.manifest.items.isEmpty, "EPUB requires manifest items")
        
        // Spine requirements  
        #expect(!document.spine.items.isEmpty, "EPUB requires spine items")
        
        // Navigation requirements (TOC)
        #expect(!document.tableOfContents.label.isEmpty, "EPUB requires navigation structure")
    }
}
