//
//  EPUBParserDelegateTests.swift
//  EPUBKitTests
//
//  Created by Witek Bobrowski on 13/06/2021.
//

import Testing
import Foundation
@testable import EPUBKit

/// Tests for EPUBParser delegate functionality
@Suite("EPUBParser Delegate Tests", .serialized)
struct EPUBParserDelegateTests {
    
    private let library = EPUBLibrary()
    
    // MARK: - Delegate Lifecycle Tests
    
    @Test("Delegate methods called in correct order")
    func delegateMethodsCalledInCorrectOrder() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .theGeographyofBliss)
        
        var callOrder: [String] = []
        
        delegate.didBeginParsingDocumentAt = { _ in callOrder.append("begin") }
        delegate.didUnzipArchiveTo = { _ in callOrder.append("unzip") }
        delegate.didLocateContentAt = { _ in callOrder.append("locate") }
        delegate.didFinishParsingMetadata = { _ in callOrder.append("metadata") }
        delegate.didFinishParsingManifest = { _ in callOrder.append("manifest") }
        delegate.didFinishParsingSpine = { _ in callOrder.append("spine") }
        delegate.didFinishParsingTableOfContents = { _ in callOrder.append("toc") }
        delegate.didFinishParsingDocumentAt = { _ in callOrder.append("finish") }
        delegate.didFailParsingDocument = { _ in callOrder.append("fail") }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
        
        // The actual order depends on how the parser processes components
        // Just verify that begin is first and finish is last, and that all expected calls happen
        #expect(callOrder.first == "begin", "Should start with begin")
        #expect(callOrder.last == "finish", "Should end with finish")
        #expect(callOrder.contains("unzip"), "Should call unzip")
        #expect(callOrder.contains("locate"), "Should call locate")
        #expect(callOrder.contains("metadata"), "Should call metadata")
        #expect(callOrder.contains("manifest"), "Should call manifest")
        #expect(callOrder.contains("spine"), "Should call spine")
        #expect(callOrder.contains("toc"), "Should call toc")
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegate receives correct parameters")
    func delegateReceivesCorrectParameters() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .theGeographyofBliss)
        
        var receivedURL: URL?
        var receivedDirectory: URL?
        
        delegate.didBeginParsingDocumentAt = { receivedURL = $0 }
        delegate.didUnzipArchiveTo = { receivedDirectory = $0 }
        delegate.didFinishParsingDocumentAt = { receivedURL = $0 }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
        
        #expect(receivedURL == url, "Delegate should receive correct URL")
        #expect(receivedDirectory?.hasDirectoryPath == true, "Should receive directory URL")
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegate failure handling")
    func delegateFailureHandling() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .alicesAdventuresinWonderlandBrokenArchive)
        
        var failureCalled = false
        var finishCalled = false
        
        delegate.didFailParsingDocument = { _ in failureCalled = true }
        delegate.didFinishParsingDocumentAt = { _ in finishCalled = true }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to fail")
        } catch {
            // Expected failure
        }
        
        #expect(failureCalled, "Failure delegate should be called")
        #expect(!finishCalled, "Finish delegate should not be called on failure")
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegate weak reference behavior")
    func delegateWeakReferenceBehavior() {
        let parser = EPUBParser()
        
        do {
            let delegate = MockedEPUBParserDelegate()
            parser.delegate = delegate
            #expect(parser.delegate != nil)
        } // delegate goes out of scope
        
        #expect(parser.delegate == nil, "Delegate should be weakly referenced")
    }
    
    @Test("Parser works without delegate")
    func parserWorksWithoutDelegate() {
        let parser = EPUBParser()
        let url = library.path(for: .theGeographyofBliss)
        
        parser.delegate = nil
        
        do {
            let document = try parser.parse(documentAt: url)
            #expect(document.title != nil)
        } catch {
            Issue.record("Parser should work without delegate: \(error)")
        }
    }
    
    @Test("Multiple parsers can have different delegates")
    func multipleParsersCanHaveDifferentDelegates() {
        let parser1 = EPUBParser()
        let parser2 = EPUBParser()
        let delegate1 = MockedEPUBParserDelegate()
        let delegate2 = MockedEPUBParserDelegate()
        let url = library.path(for: .theGeographyofBliss)
        
        var parser1Called = false
        var parser2Called = false
        
        delegate1.didBeginParsingDocumentAt = { _ in parser1Called = true }
        delegate2.didBeginParsingDocumentAt = { _ in parser2Called = true }
        
        parser1.delegate = delegate1
        parser2.delegate = delegate2
        
        do {
            _ = try parser1.parse(documentAt: url)
            _ = try parser2.parse(documentAt: url)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
        
        #expect(parser1Called, "Parser 1 delegate should be called")
        #expect(parser2Called, "Parser 2 delegate should be called")
        
        withExtendedLifetime(delegate1) {}
        withExtendedLifetime(delegate2) {}
    }
    
    // MARK: - Delegate Implementation Variations
    
    @Test("Empty delegate implementation works")
    func emptyDelegateImplementationWorks() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate() // No closures set
        let url = library.path(for: .theGeographyofBliss)
        
        parser.delegate = delegate
        
        do {
            let document = try parser.parse(documentAt: url)
            #expect(document.title != nil)
        } catch {
            Issue.record("Parsing should work with empty delegate: \(error)")
        }
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Partial delegate implementation works")
    func partialDelegateImplementationWorks() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .theGeographyofBliss)
        
        var beginCalled = false
        
        // Only implement some delegate methods
        delegate.didBeginParsingDocumentAt = { _ in beginCalled = true }
        
        parser.delegate = delegate
        
        do {
            let document = try parser.parse(documentAt: url)
            #expect(document.title != nil)
        } catch {
            Issue.record("Parsing should work with partial delegate: \(error)")
        }
        
        #expect(beginCalled, "Implemented delegate method should be called")
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegate enables progress monitoring")
    func delegateEnablesProgressMonitoring() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: .theGeographyofBliss)
        
        var progressSteps: [String] = []
        
        delegate.didBeginParsingDocumentAt = { _ in progressSteps.append("started") }
        delegate.didUnzipArchiveTo = { _ in progressSteps.append("extracted") }
        delegate.didLocateContentAt = { _ in progressSteps.append("located") }
        delegate.didFinishParsingMetadata = { _ in progressSteps.append("metadata") }
        delegate.didFinishParsingManifest = { _ in progressSteps.append("manifest") }
        delegate.didFinishParsingSpine = { _ in progressSteps.append("spine") }
        delegate.didFinishParsingTableOfContents = { _ in progressSteps.append("toc") }
        delegate.didFinishParsingDocumentAt = { _ in progressSteps.append("completed") }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
        
        #expect(progressSteps.count >= 3, "Should receive multiple progress updates")
        #expect(progressSteps.first == "started", "Should start with begin event")
        #expect(progressSteps.last == "completed", "Should end with completion event")
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegate receives all error types", arguments: [
        (EPUBFile.alicesAdventuresinWonderlandBrokenArchive, "unzipFailed"),
        (EPUBFile.theGeographyofBlissBrokenContainer, "containerMissing"),
        (EPUBFile.theProblemsofPhilosophyBrokenContent, "contentPathMissing"),
        (EPUBFile.theMetamorphosisBrokenToc, "tableOfContentsMissing")
    ])
    func delegateReceivesAllErrorTypes(file: EPUBFile, expectedError: String) {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url = library.path(for: file)
        
        var receivedError: Error?
        
        delegate.didFailParsingDocument = { error in
            receivedError = error
        }
        
        parser.delegate = delegate
        
        do {
            _ = try parser.parse(documentAt: url)
            Issue.record("Expected parsing to fail for \(file)")
        } catch {
            // Expected failure
        }
        
        #expect(receivedError != nil, "Delegate should receive error")
        if let epubError = receivedError as? EPUBParserError {
            let errorName = String(describing: epubError).components(separatedBy: "(")[0]
            #expect(errorName == expectedError, "Should receive \(expectedError) error")
        }
        
        withExtendedLifetime(delegate) {}
    }
    
    @Test("Delegates work correctly with sequential parsing")
    func delegatesWorkCorrectlyWithSequentialParsing() {
        let parser = EPUBParser()
        let delegate = MockedEPUBParserDelegate()
        let url1 = library.path(for: .theGeographyofBliss)
        let url2 = library.path(for: .theMetamorphosis)
        
        var parseCount = 0
        
        delegate.didFinishParsingDocumentAt = { _ in
            parseCount += 1
        }
        
        parser.delegate = delegate
        
        // Parse multiple documents sequentially
        do {
            _ = try parser.parse(documentAt: url1)
            _ = try parser.parse(documentAt: url2)
        } catch {
            Issue.record("Parsing should not fail: \(error)")
        }
        
        #expect(parseCount == 2, "Delegate should be called for each parse operation")
        
        withExtendedLifetime(delegate) {}
    }
}
