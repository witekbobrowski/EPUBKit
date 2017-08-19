//
//  EPUBDocument.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBDocument {
    
    var directory: URL
    var contentDirectory: URL
    var metadata: EPUBMetadata
    var manifest: EPUBManifest
    var spine: EPUBSpine
    var tableOfContents: EPUBTableOfContents
    
    public var title: String? {
        return metadata.title
    }
    public var author: String? {
        return metadata.creator?.name
    }
    public var publisher: String? {
        return metadata.publisher
    }
    public var cover: URL? {
        return contentDirectory.appendingPathComponent(manifest.children[metadata.coverId ?? ""]?.path ?? "")
    }
    
    private init (directory: URL, contentDirectory: URL, metadata: EPUBMetadata, manifest: EPUBManifest, spine: EPUBSpine, toc: EPUBTableOfContents) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = toc
    }
    
    public convenience init?(named: String) {
        let parser = try? EPUBParser(named: named)
        guard let directory = parser?.directory, let contentDirectory = parser?.contentDirectory,
            let metadata = parser?.metadata, let manifest = parser?.manifest,
            let spine = parser?.spine, let tableOfContents = parser?.tableOfContents else { return nil }
        self.init(directory: directory, contentDirectory: contentDirectory, metadata: metadata, manifest: manifest, spine: spine, toc: tableOfContents)
    }
}
