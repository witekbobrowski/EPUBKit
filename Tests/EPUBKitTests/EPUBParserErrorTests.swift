//
//  EPUBParserErrorTests.swift
//  EPUBKitTests
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for EPUBParser error handling and edge cases
@Suite("EPUBParser Error Tests", .serialized)
struct EPUBParserErrorTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Basic Error Tests
    
    @Test("Handle broken archive")
    func handleBrokenArchive() {
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        let parser = EPUBParser()
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to throw an error")
        } catch let error as EPUBParserError {
            guard case .unzipFailed = error else {
                Issue.record("Wrong error thrown, expected unzipFailed")
                return
            }
            #expect(error.errorDescription != nil)
            #expect(error.failureReason != nil)
            #expect(error.recoverySuggestion != nil)
        } catch {
            Issue.record("Error should be of type EPUBParserError, got: \(error)")
        }
    }
    
    @Test("Handle missing container")
    func handleMissingContainer() {
        let url = library.path(for: .theGeographyofBlissBrokenContainer)
        let parser = EPUBParser()
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to throw an error")
        } catch let error as EPUBParserError {
            guard case .containerMissing = error else {
                Issue.record("Wrong error thrown, expected containerMissing: \(error)")
                return
            }
            #expect(error.errorDescription != nil)
            #expect(error.failureReason != nil)
            #expect(error.recoverySuggestion != nil)
        } catch {
            Issue.record("Error should be of type EPUBParserError, got: \(error)")
        }
    }
    
    @Test("Handle missing table of contents")
    func handleMissingTableOfContents() {
        let url = library.path(for: .theMetamorphosisBrokenToc)
        let parser = EPUBParser()
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to throw an error")
        } catch let error as EPUBParserError {
            guard case .tableOfContentsMissing = error else {
                Issue.record("Wrong error thrown, expected tableOfContentsMissing: \(error)")
                return
            }
            #expect(error.errorDescription != nil)
            #expect(error.failureReason != nil)
            #expect(error.recoverySuggestion != nil)
        } catch {
            Issue.record("Error should be of type EPUBParserError, got: \(error)")
        }
    }
    
    @Test("Handle missing content path")
    func handleMissingContentPath() {
        let url = library.path(for: .theProblemsofPhilosophyBrokenContent)
        let parser = EPUBParser()
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to throw an error")
        } catch let error as EPUBParserError {
            guard case .contentPathMissing = error else {
                Issue.record("Wrong error thrown, expected contentPathMissing: \(error)")
                return
            }
            #expect(error.errorDescription != nil)
            #expect(error.failureReason != nil)
            #expect(error.recoverySuggestion != nil)
        } catch {
            Issue.record("Error should be of type EPUBParserError, got: \(error)")
        }
    }
    
    // MARK: - File System Error Tests
    
    @Test("Handle nonexistent file")
    func handleNonexistentFile() {
        let parser = EPUBParser()
        let url = URL(fileURLWithPath: "/nonexistent/file.epub")
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to fail")
        } catch {
            // Expected failure
        }
    }
    
    @Test("Handle invalid file permissions")
    func handleInvalidFilePermissions() {
        let parser = EPUBParser()
        // Try to access a system directory that should not be accessible
        let url = URL(fileURLWithPath: "/etc/passwd.epub")
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to fail")
        } catch {
            // Expected failure
        }
    }
    
    // MARK: - Delegate Error Handling
    
    @Test("Handle broken archive with delegate")
    func handleBrokenArchiveWithDelegate() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        
        var beginCalled = false
        var failureCalled = false
        var finishCalled = false
        
        delegate.didBeginParsingDocumentAt = { _ in beginCalled = true }
        delegate.didFinishParsingDocumentAt = { _ in finishCalled = true }
        delegate.didFailParsingDocument = { _ in failureCalled = true }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to fail")
        } catch {
            // Expected failure
        }
        
        #expect(beginCalled, "Begin parsing should be called")
        #expect(failureCalled, "Failure callback should be called")
        #expect(!finishCalled, "Finish should not be called on failure")
        
        withExtendedLifetime(delegate) {}
    }
    
    // MARK: - EPUBDocument Error Handling
    
    @Test("EPUBDocument init returns nil for broken archives")
    func epubDocumentInitReturnsNilForBrokenArchives() {
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
    }
    
    @Test("EPUBDocument init returns nil for nonexistent file")
    func epubDocumentInitReturnsNilForNonexistentFile() {
        let url = URL(fileURLWithPath: "/nonexistent/file.epub")
        let document = EPUBDocument(url: url)
        #expect(document == nil, "Document creation should fail for nonexistent file")
    }
    
    // MARK: - Error Message Validation
    
    @Test("Validate all error messages are meaningful")
    func validateAllErrorMessagesAreMeaningful() {
        let allErrors: [EPUBParserError] = [
            .unzipFailed(reason: CocoaError(.fileReadCorruptFile)),
            .containerMissing,
            .contentPathMissing,
            .tableOfContentsMissing
        ]
        
        for error in allErrors {
            #expect(error.errorDescription != nil, "Error description should not be nil")
            #expect(!error.errorDescription!.isEmpty, "Error description should not be empty")
            
            #expect(error.failureReason != nil, "Failure reason should not be nil")
            #expect(!error.failureReason!.isEmpty, "Failure reason should not be empty")
            
            #expect(error.recoverySuggestion != nil, "Recovery suggestion should not be nil")
            #expect(!error.recoverySuggestion!.isEmpty, "Recovery suggestion should not be empty")
        }
    }
    
    @Test("Errors provide proper context")
    func errorsProvideProperContext() {
        let parser = EPUBParser()
        
        // Test each error type with its corresponding broken file
        let errorTests: [(EPUBFile, String)] = [
            (.alicesAdventuresinWonderlandBrokenArchive, "unzipFailed"),
            (.theGeographyofBlissBrokenContainer, "containerMissing"),
            (.theProblemsofPhilosophyBrokenContent, "contentPathMissing"),
            (.theMetamorphosisBrokenToc, "tableOfContentsMissing")
        ]
        
        for (file, _) in errorTests {
            let url = library.path(for: file)
            
            do {
                _ = try parser.parse(documentAt: url)
                Issue.record("Expected parsing to fail for \(file)")
            } catch let error as EPUBParserError {
                // Error should be localized
                let nsError = error as NSError
                #expect(nsError.localizedDescription.count > 0)
                #expect(nsError.localizedFailureReason?.count ?? 0 > 0)
                #expect(nsError.localizedRecoverySuggestion?.count ?? 0 > 0)
            } catch {
                Issue.record("Expected EPUBParserError for \(file), got \(error)")
            }
        }
    }
    
    @Test("Error recovery suggestions are actionable")
    func errorRecoverySuggestionsAreActionable() {
        let errors: [EPUBParserError] = [
            .unzipFailed(reason: CocoaError(.fileReadCorruptFile)),
            .containerMissing,
            .contentPathMissing,
            .tableOfContentsMissing
        ]
        
        for error in errors {
            let suggestion = error.recoverySuggestion!
            
            // Recovery suggestions should mention specific actions
            let hasActionableAdvice = suggestion.contains("Make sure") ||
                                    suggestion.contains("Try") ||
                                    suggestion.contains("Check") ||
                                    suggestion.contains("check") ||
                                    suggestion.contains("may be")
            
            #expect(hasActionableAdvice, "Recovery suggestion should be actionable: \(suggestion)")
        }
    }
}
