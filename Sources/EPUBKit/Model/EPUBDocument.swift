//
//  EPUBDocument.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation
import OSLog

public struct EPUBDocument {

    public let directory: URL
    public let contentDirectory: URL
    public let metadata: EPUBMetadata
    public let manifest: EPUBManifest
    public let spine: EPUBSpine
    public let tableOfContents: EPUBTableOfContents

    init(
        directory: URL,
        contentDirectory: URL,
        metadata: EPUBMetadata,
        manifest: EPUBManifest,
        spine: EPUBSpine,
        tableOfContents: EPUBTableOfContents
    ) {
        self.directory = directory
        self.contentDirectory = contentDirectory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = tableOfContents
    }

    public init?(url: URL) {
        guard let document = try? EPUBParser().parse(documentAt: url) else {
            return nil
        }
        self = document
    }

    public init?(data: Data) {
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let tempFile = cacheDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("epub")
        defer {
            try? FileManager.default.removeItem(at: tempFile)
        }
        
        do {
            try data.write(to: tempFile, options: .atomic)
            
            let document = try EPUBParser().parse(documentAt: tempFile)
            self = document
        } catch {
            Logger().error("\(error.localizedDescription)")
            return nil
        }
    }
}

extension EPUBDocument {
    public var title: String? { metadata.title }
    public var author: String? { metadata.creator?.name }
    public var publisher: String? { metadata.publisher }
    public var cover: URL? {
        guard let coverId = metadata.coverId, let path = manifest.items[coverId]?.path else {
            return nil
        }
        return contentDirectory.appendingPathComponent(path)
    }
}
