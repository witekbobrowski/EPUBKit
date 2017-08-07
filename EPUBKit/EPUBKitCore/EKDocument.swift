//
//  EPUBDocumnet.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public protocol Parsable {
    
    init?(fileName: String)
    
}

public class EPUBDocument: Parsable {
    
    var directory: URL
    var contentDirectory: URL
    var metadata: EPUBMetadata
    var manifest: EPUBManifest
    var spine: EPUBSpine
    var tableOfContents: EPUBTableOfContents
    
    init (directory: URL, contentDirectory: URL, metadata: EPUBMetadata, manifest: EPUBManifest, spine: EPUBSpine, toc: EPUBTableOfContents) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = toc
    }
    
    public required convenience init?(fileName: String) {
        do {
            let book = try EPUBParser.parse(fileName)
            self.init(directory: book.directory, contentDirectory: book.contentDirectory, metadata: book.metadata, manifest: book.manifest, spine: book.spine, toc: book.tableOfContents)
        } catch {
            return nil
        }
    }
    
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
    
}
