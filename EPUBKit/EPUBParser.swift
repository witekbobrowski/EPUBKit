//
//  EPUBParser.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Zip
import AEXML
import Foundation

enum EPUBParserError: Error {
    case UnZipError
    case ContainterParseError
    case NoPathForContent
    case MetaDataParseError
    case ContentsParseError
    case TOCParseError
}


public class EPUBParser {
    
    class public func parse(_ fileName: String) throws -> EPUBDocument {
        do {
            let directory = try unzip(fileName)
            let content = try getContentDirectory(from: directory)
            return try getDocument(with: content)
        } catch let error {
            throw error
        }
    }
    
    class private func unzip(_ name: String) throws -> URL {
        Zip.addCustomFileExtension("epub")
        do {
            let filePath = Bundle.main.url(forResource: name, withExtension: "epub")!
            let unzipDirectory = try Zip.quickUnzipFile(filePath)
            return unzipDirectory
        } catch ZipError.unzipFail {
            throw EPUBParserError.UnZipError
        }
    }
    
    class private func getContentDirectory(from bookDirectory: URL) throws -> URL {
        do {
            let path = Bundle.main.url(forResource: "container", withExtension: "xml", subdirectory: bookDirectory.absoluteString)
            let data = try Data(contentsOf: path!)
            let container = try AEXMLDocument(xml: data)
            let content = container.root["rootfiles"]["rootfile"].attributes["full-path"]
            if content != nil {
                return URL(fileURLWithPath: content!)
            } else {
                throw EPUBParserError.NoPathForContent
            }
        } catch {
            throw EPUBParserError.ContainterParseError
        }
    }
    
    class private func getDocument(with path: URL) throws -> EPUBDocument {
        do {
            let data = try Data(contentsOf: path)
            let content = try AEXMLDocument(xml: data)
            let metadata = try getMetadata(from: content.root["metadata"])
            let contents = try getContents(from: content)
            let tableOfContents = try getTableOfContents(from: content)
            return EPUBDocument(metadata: metadata, contents: contents, toc: tableOfContents)
        } catch let error {
            throw error
        }
        
    }
    
    class private func getMetadata(from content: AEXMLElement) throws -> EPUBMetadata {
        let metadata = EPUBMetadata()
        metadata.contributor = EPUBCreator(name: content["dc:contributor"].value,
                                           role: content["dc:contributor"].attributes["opf:role"],
                                           fileAs: content["dc:contributor"].attributes["opf:file-as"])
        metadata.coverage = content["dc:coverage"].value
        metadata.creator = EPUBCreator(name: content["dc:creator"].value,
                                       role: content["dc:creator"].attributes["opf:role"],
                                       fileAs: content["dc:creator"].attributes["opf:file-as"])
        metadata.date = content["dc:date"].value
        metadata.description = content["dc:description"].value
        metadata.format = content["dc:format"].value
        metadata.identifier = content["dc:identifier"].value
        metadata.language = content["dc:language"].value
        metadata.publisher = content["dc:publisher"].value
        metadata.relation = content["dc:relation"].value
        metadata.rights = content["dc:rights"].value
        metadata.source = content["dc:source"].value
        metadata.subject = content["dc:subject"].value
        metadata.title = content["dc:title"].value
        metadata.type = content["dc:type"].value
        return metadata
    }
    
    class private func getContents(from content: AEXMLElement) throws -> EPUBContents {
        do {
            
        } catch {
            throw EPUBParserError.ContentsParseError
        }
    }
    
    class private func getTableOfContents(from content: AEXMLElement) throws -> EPUBTableOfContents {
        do {
            
        } catch {
            throw EPUBParserError.TOCParseError
        }
    }
    
}


