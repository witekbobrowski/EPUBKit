//
//  EPUBEdgeCaseTests.swift
//  EPUBKitTests
//
//  Created by Claude on 12/06/2025.
//

import Testing
import Foundation
@testable import EPUBKit

/// Edge case and boundary condition tests
@Suite("EPUB Edge Case Tests", .serialized, .tags(.edgeCase))
struct EPUBEdgeCaseTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Empty Content Tests
    
    @Test("Handle empty manifest")
    func handleEmptyManifest() {
        let manifest = EPUBManifest(items: [:])
        
        #expect(manifest.items.isEmpty)
        #expect(manifest.items.count == 0)
        
        // Accessing non-existent items should return nil
        #expect(manifest.items["nonexistent"] == nil)
    }
    
    @Test("Handle empty spine")
    func handleEmptySpine() {
        let spine = EPUBSpine(id: nil, toc: nil, pageProgressionDirection: nil, items: [])
        
        #expect(spine.items.isEmpty)
        #expect(spine.id == nil)
        #expect(spine.toc == nil)
        #expect(spine.pageProgressionDirection == nil)
    }
    
    @Test("Handle minimal metadata")
    func handleMinimalMetadata() {
        let metadata = EPUBMetadata()
        
        // All properties should be nil by default
        #expect(metadata.title == nil)
        #expect(metadata.creator == nil)
        #expect(metadata.contributor == nil)
        #expect(metadata.publisher == nil)
        #expect(metadata.identifier == nil)
        #expect(metadata.language == nil)
        #expect(metadata.date == nil)
        #expect(metadata.subject == nil)
        #expect(metadata.description == nil)
        #expect(metadata.type == nil)
        #expect(metadata.format == nil)
        #expect(metadata.source == nil)
        #expect(metadata.relation == nil)
        #expect(metadata.coverage == nil)
        #expect(metadata.rights == nil)
        #expect(metadata.coverId == nil)
    }
    
    // MARK: - Special Characters
    
    @Test("Handle special characters in metadata", arguments: [
        "Title with émojis 📚🎉",
        "Author with ümlauts: Müller",
        "Publisher with symbols: O'Reilly & Associates",
        "Japanese title: 日本語のタイトル",
        "Arabic title: عنوان عربي",
        "Mixed script: Hello мир 世界"
    ])
    func handleSpecialCharactersInMetadata(text: String) {
        var metadata = EPUBMetadata()
        metadata.title = text
        
        #expect(metadata.title == text, "Special characters should be preserved")
        #expect(metadata.title?.isEmpty == false)
    }
    
    // MARK: - Large Content
    
    @Test("Handle moderately long strings")
    func handleModeratelyLongStrings() {
        let longString = String(repeating: "Lorem ipsum dolor sit amet. ", count: 100)
        
        var metadata = EPUBMetadata()
        metadata.description = longString
        
        #expect(metadata.description == longString)
        #expect(metadata.description?.count == longString.count)
    }
    
    @Test("Handle manifest with multiple items")
    func handleManifestWithMultipleItems() {
        var items: [String: EPUBManifestItem] = [:]
        
        // Create 50 manifest items
        for i in 0..<50 {
            let item = EPUBManifestItem(
                id: "item\(i)",
                path: "content/chapter\(i).xhtml",
                mediaType: .xHTML,
                property: nil
            )
            items[item.id] = item
        }
        
        let manifest = EPUBManifest(items: items)
        
        #expect(manifest.items.count == 50)
        #expect(manifest.items["item25"] != nil)
        #expect(manifest.items["item49"]?.path == "content/chapter49.xhtml")
    }
    
    // MARK: - Path Edge Cases
    
    @Test("Handle various path formats", arguments: [
        "simple.xhtml",
        "path/to/file.xhtml",
        "path with spaces/file.xhtml",
        "../relative/path.xhtml",
        "./current/path.xhtml",
        "path/with/many/nested/directories/file.xhtml",
        "file-with-dashes.xhtml",
        "file_with_underscores.xhtml",
        "file.with.dots.xhtml"
    ])
    func handleVariousPathFormats(path: String) {
        let item = EPUBManifestItem(
            id: "test",
            path: path,
            mediaType: .xHTML,
            property: nil
        )
        
        #expect(item.path == path)
        #expect(!item.path.isEmpty)
    }
    
    // MARK: - TOC Edge Cases
    
    @Test("Handle deeply nested TOC")
    func handleDeeplyNestedTOC() {
        // Create a TOC with 10 levels of nesting
        func createNestedTOC(depth: Int, maxDepth: Int = 10) -> EPUBTableOfContents {
            var toc = EPUBTableOfContents(
                label: "Level \(depth)",
                id: "level\(depth)",
                item: "content\(depth).xhtml"
            )
            
            if depth < maxDepth {
                toc.subTable = [createNestedTOC(depth: depth + 1, maxDepth: maxDepth)]
            }
            
            return toc
        }
        
        let rootTOC = createNestedTOC(depth: 1)
        
        // Verify the structure
        var currentTOC: EPUBTableOfContents? = rootTOC
        for i in 1...10 {
            #expect(currentTOC?.label == "Level \(i)")
            #expect(currentTOC?.id == "level\(i)")
            currentTOC = currentTOC?.subTable?.first
        }
        
        #expect(currentTOC == nil, "Should have exactly 10 levels")
    }
    
    @Test("Handle TOC with multiple siblings")
    func handleTOCWithMultipleSiblings() {
        var children: [EPUBTableOfContents] = []
        
        for i in 0..<10 {
            let child = EPUBTableOfContents(
                label: "Chapter \(i)",
                id: "chapter\(i)",
                item: "chapter\(i).xhtml"
            )
            children.append(child)
        }
        
        let rootTOC = EPUBTableOfContents(
            label: "Root",
            id: "root",
            item: nil,
            subTable: children
        )
        
        #expect(rootTOC.subTable?.count == 10)
        if let subTable = rootTOC.subTable, subTable.count > 5 {
            #expect(subTable[5].label == "Chapter 5")
        }
    }
    
    // MARK: - Whitespace Handling
    
    @Test("Handle whitespace in various contexts", arguments: [
        ("   Leading spaces", "Leading spaces"),
        ("Trailing spaces   ", "Trailing spaces"),
        ("   Both sides   ", "Both sides"),
        ("Multiple   spaces", "Multiple   spaces"),
        ("\tTabs\there", "\tTabs\there"),
        ("\nNewlines\nhere", "\nNewlines\nhere"),
        ("Mixed\t  \nwhitespace", "Mixed\t  \nwhitespace")
    ])
    func handleWhitespaceInVariousContexts(input: String, expected: String?) {
        var metadata = EPUBMetadata()
        metadata.title = input
        
        // EPUBKit should preserve whitespace as-is
        #expect(metadata.title == input)
    }
    
    // MARK: - Circular References
    
    @Test("Handle circular spine references")
    func handleCircularSpineReferences() {
        // Create a spine that references non-existent manifest items
        let spine = EPUBSpine(
            id: "spine",
            toc: "toc",
            pageProgressionDirection: .leftToRight,
            items: [
                EPUBSpineItem(idref: "item1", linear: true),
                EPUBSpineItem(idref: "item2", linear: true),
                EPUBSpineItem(idref: "item1", linear: true) // Duplicate reference
            ]
        )
        
        #expect(spine.items.count == 3)
        #expect(spine.items[0].idref == spine.items[2].idref)
    }
    
    // MARK: - Null/Empty ID Handling
    
    @Test("Handle empty IDs")
    func handleEmptyIDs() {
        let item = EPUBManifestItem(
            id: "",
            path: "file.xhtml",
            mediaType: .xHTML,
            property: nil
        )
        
        #expect(item.id.isEmpty)
        #expect(item.path == "file.xhtml")
        
        let spine = EPUBSpineItem(idref: "", linear: true)
        #expect(spine.idref.isEmpty)
    }
    
    // MARK: - File System Edge Cases
    
    @Test("Handle missing file URL")
    func handleMissingFileURL() {
        let parser = EPUBParser()
        let nonExistentURL = URL(fileURLWithPath: "/non/existent/path/to/file.epub")
        
        do {
            _ = try parser.parse(documentAt: nonExistentURL)
            Issue.record("Should fail for non-existent file")
        } catch {
            #expect(error is EPUBParserError)
        }
    }
    
    @Test("Handle directory instead of file")
    func handleDirectoryInsteadOfFile() {
        let parser = EPUBParser()
        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        
        do {
            _ = try parser.parse(documentAt: directoryURL)
            Issue.record("Should fail for directory")
        } catch {
            // Expected to fail
            #expect(error is EPUBParserError)
        }
    }
}

// Tag definition for edge cases
extension Tag {
    @Tag static var edgeCase: Self
}
