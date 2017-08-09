//
//  EKDocument.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EKDocument {
    
    var directory: URL
    var contentDirectory: URL
    var metadata: EKMetadata
    var manifest: EKManifest
    var spine: EKSpine
    var tableOfContents: EKTableOfContents
    
    public var title: String {
        return metadata.title ?? "Untitled"
    }
    
    public var author: String {
        return metadata.creator?.name ?? "Author unknown"
    }
    
    public var publisher: String {
        return metadata.publisher ?? "Publisher unknown"
    }
    
    public var cover: URL? {
        return contentDirectory.appendingPathComponent(manifest.children[metadata.coverId ?? ""]?.path ?? "")
    }
    
    init (directory: URL, contentDirectory: URL, metadata: EKMetadata, manifest: EKManifest, spine: EKSpine, toc: EKTableOfContents) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = toc
    }
    
    public required convenience init?(fileName: String) {
        do {
            let book = try EKParser.parse(fileName)
            self.init(directory: book.directory, contentDirectory: book.contentDirectory, metadata: book.metadata, manifest: book.manifest, spine: book.spine, toc: book.tableOfContents)
        } catch {
            return nil
        }
    }
}
