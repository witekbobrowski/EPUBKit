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
//        Bundle.module.resourceURL!.appendingPathComponent(file.fullName)
    }

}

// https://stackoverflow.com/questions/47177036
#if Xcode
extension Foundation.Bundle {

    /// Returns the resource bundle associated with the current Swift module.
    /// Returns resource bundle as a `Bundle`.
    /// Requires Xcode copy phase to locate files into `ExecutableName.bundle`;
    /// or `ExecutableNameTests.bundle` for test resources
    static var module: Bundle = {
        var url = Bundle.main.bundleURL
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            url = bundle.bundleURL.deletingLastPathComponent()
        }
        url = url.appendingPathComponent("EPUBKit_EPUBKitTests.bundle")
        guard let bundle = Bundle(url: url) else {
            fatalError("Foundation.Bundle.module could not load resource bundle: \(url.path)")
        }
        return bundle
    }()

}
#endif
