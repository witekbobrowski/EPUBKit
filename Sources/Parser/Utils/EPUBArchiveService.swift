//
//  EPUBArchiveService.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import Zip

protocol EPUBArchiveService {
    func archive(filesAt url: URL, fileName name: String) throws -> URL
    func unarchive(archive url: URL) throws -> URL
}

class EPUBArchiveServiceImplementation: EPUBArchiveService {

    init() {
        Zip.addCustomFileExtension("epub")
    }

    func archive(filesAt url: URL, fileName name: String) throws -> URL {
        return try Zip.quickZipFiles([url], fileName: name)
    }

    func unarchive(archive url: URL) throws -> URL {
        do {
            return try Zip.quickUnzipFile(url)
        } catch let error {
            throw EPUBParserError.unzipFailed(reason: error)
        }
    }

}
