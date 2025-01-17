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
    func unarchive(archive url: URL) throws -> URL
}

class EPUBArchiveServiceImplementation: EPUBArchiveService {

    init() {
        Zip.addCustomFileExtension("epub")
    }

    func unarchive(archive url: URL) throws -> URL {
        var destination: URL
        do {
            destination = URL.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            try Zip.unzipFile(url, destination: destination, overwrite: true, password: nil)
        } catch {
            throw EPUBParserError.unzipFailed(reason: error)
        }
        return destination
    }

}
