//
//  EPUBLibrary.swift
//  EPUBKit-iOS
//
//  Created by Witek Bobrowski on 01/07/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import EPUBKit

protocol FileLibrary {
    func path(for file: EPUBFile) -> URL
}

class EPUBLibrary: FileLibrary {

    func path(for file: EPUBFile) -> URL {
        if let url = Bundle(for: EPUBLibrary.self)
            .url(forResource: file.fileName, withExtension: file.fileExtension) {
            return url
        } else {
            guard let url = Bundle.module.url(forResource: "Resources/\(file.fileName)", withExtension: file.fileExtension) else {
                fatalError("can't find resource named: '\(file.fileName)'")
            }
            return url
        }
    }

}
