//
//  EKParser.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Zip
import AEXML
import Foundation

public class EKParser {
    
    class public func parse(_ fileName: String) throws -> EKDocument {
        do {
            let directory = try unzip(fileName)
            let contentPath = try getContentPath(from: directory)
            let contentDirectory = contentPath.deletingLastPathComponent()
            let data = try Data(contentsOf: contentPath)
            let content = try AEXMLDocument(xml: data)
            let metadata = getMetadata(from: content.root["metadata"])
            let manifest = getManifest(from: content.root["manifest"])
            let spine =  getSpine(from: content.root["spine"])
            let tocPath = contentDirectory.appendingPathComponent(try manifest.getTOCPath(id: try spine.getTOCid()))
            let tocData = try Data(contentsOf: tocPath)
            let tocContent = try AEXMLDocument(xml: tocData)
            let toc = getTableOfContents(from: tocContent.root)
            return EKDocument(directory: directory, contentDirectory: contentDirectory, metadata: metadata, manifest: manifest, spine: spine, toc: toc)
        } catch {
            print(error.localizedDescription)
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
            throw EKParserError.unZipError
        }
    }
    
    class private func getContentPath(from bookDirectory: URL) throws -> URL {
        do {
            let path = bookDirectory.appendingPathComponent("META-INF/container.xml")
            let data = try Data(contentsOf: path)
            let container = try AEXMLDocument(xml: data)
            let content = container.root["rootfiles"]["rootfile"].attributes["full-path"]
            return bookDirectory.appendingPathComponent(content!)
        } catch {
            throw EKParserError.containerParseError
        }
    }
    
    class private func getMetadata(from content: AEXMLElement) -> EKMetadata {
        let metadata = EKMetadata()
        metadata.contributor = EKCreator(name: content["dc:contributor"].value,
                                           role: content["dc:contributor"].attributes["opf:role"],
                                           fileAs: content["dc:contributor"].attributes["opf:file-as"])
        metadata.coverage = content["dc:coverage"].value
        metadata.creator = EKCreator(name: content["dc:creator"].value,
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
        for metaItem in content["meta"].all! {
            if metaItem.attributes["name"] == "cover" {
                metadata.coverId = metaItem.attributes["content"]
            }
        }
        return metadata
    }
    
    class private func getManifest(from content: AEXMLElement) -> EKManifest {
        var children: [String:EKManifestItem] = [:]
        for item in content["item"].all! {
            let id = item.attributes["id"]!
            let path = item.attributes["href"]!
            let mediatype = item.attributes["media-type"]
            let properties = item.attributes["properties"]
            children[id] = EKManifestItem(id: id, path: path, mediaType: mediatype!, property: properties)
        }
        if let id = content["id"].value {
            return EKManifest(id: id, children: children)
        } else {
            return EKManifest(children: children)
        }
    }
    
    class private func getSpine(from content: AEXMLElement) -> EKSpine {
        var children: [EKSpineItem] = []
        for item in content["itemref"].all! {
            if let linear = item["linear"].value {
                children.append(EKSpineItem(id: item["id"].value, idref: item["idref"].value!, linear: linear == "yes" ? true : false))
            } else {
                children.append(EKSpineItem(id: item.attributes["id"], idref: item.attributes["idref"]!))
            }
        }
        if let ppd = content["page-progression-direction"].value {
            return EKSpine(id: content["id"].value, toc: content.attributes["toc"], pageProgressionDirection: ppd == "ltr" ? .leftToRight : .rightToLeft , children: children)
        } else {
            return EKSpine(id: content["id"].value, toc: content.attributes["toc"], children: children)
        }
    }

    class private func getTableOfContents(from toc: AEXMLElement) -> EKTableOfContents {
        let item = toc["head"]["meta"].all(withAttributes: ["name":"dtb=uid"])?.first?.attributes["content"]
        let tableOfContents = EKTableOfContents(label: toc["docTitle"]["text"].value!, id: "0", item: item, subTable: [])
        
        func evaluateChildren(from map: AEXMLElement) -> [EKTableOfContents]{
            if let _ = map["navPoint"].all {
                var subs: [EKTableOfContents] = []
                for point in map["navPoint"].all! {
                    subs.append(EKTableOfContents(label: point["navLabel"]["text"].value!, id: point.attributes["id"]!, item: point["content"].attributes["src"]!, subTable: evaluateChildren(from: point)))
                }
                return subs
            } else {
                return []
            }
        }
        tableOfContents.subTable = evaluateChildren(from: toc["navMap"])
        return tableOfContents
    }
    
}


