//
//  ArchiveService.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import Zip

protocol ArchiveService {
    func unarchive(archive url: URL) throws -> URL
}

class EPUBArchiveService: ArchiveService {

    init() {
        Zip.addCustomFileExtension("epub")
    }

    func unarchive(archive url: URL) throws -> URL {
        do {
            return try Zip.quickUnzipFile(url)
        } catch let error {
            throw EPUBParserError.unzipFailed(reason: error)
        }
    }

}
