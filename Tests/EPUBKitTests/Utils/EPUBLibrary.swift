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
        // Try class bundle first
        if let url = Bundle(for: EPUBLibrary.self)
            .url(forResource: file.fileName, withExtension: file.fileExtension) {
            return url
        }
        
        // Try module bundle with Resources prefix
        if let url = Bundle.module.url(forResource: "Resources/\(file.fileName)", withExtension: file.fileExtension) {
            return url
        }
        
        // Try module bundle without Resources prefix
        if let url = Bundle.module.url(forResource: file.fileName, withExtension: file.fileExtension) {
            return url
        }
        
        // Try test bundle for SPM
        if let testBundle = Bundle.allBundles.first(where: { $0.bundlePath.contains("EPUBKitTests") }),
           let url = testBundle.url(forResource: file.fileName, withExtension: file.fileExtension) {
            return url
        }
        
        // Create a non-existent URL that will cause tests to fail gracefully
        return URL(fileURLWithPath: "/tmp/missing-\(file.fileName).\(file.fileExtension)")
    }

}
