//
//  EPUBDocument.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBDocument {
    
    public let directory: URL
    public let contentDirectory: URL
    public let metadata: EPUBMetadata
    public let manifest: EPUBManifest
    public let spine: EPUBSpine
    public let tableOfContents: EPUBTableOfContents

    private init (directory: URL, contentDirectory: URL, metadata: EPUBMetadata, manifest: EPUBManifest, spine: EPUBSpine, toc: EPUBTableOfContents) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = toc
    }
    
    public convenience init?(url: URL) {
        let parser = try? EPUBParser(url: url)
        guard let directory = parser?.directory,
            let contentDirectory = parser?.contentDirectory,
            let metadata = parser?.metadata,
            let manifest = parser?.manifest,
            let spine = parser?.spine,
            let tableOfContents = parser?.tableOfContents else { return nil }
        self.init(directory: directory, contentDirectory: contentDirectory, metadata: metadata, manifest: manifest, spine: spine, toc: tableOfContents)
    }
}

//MARK: - Public
extension EPUBDocument {
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
        return contentDirectory.appendingPathComponent(manifest.items[metadata.coverId ?? ""]?.path ?? "")
    }
}
