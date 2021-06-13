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
        Bundle.module.resourceURL!.appendingPathComponent(file.fullName)
    }

}

// https://stackoverflow.com/questions/47177036
#if Xcode
extension Foundation.Bundle {

    /// Returns resource bundle as a `Bundle`.
    /// Requires Xcode copy phase to locate files into `ExecutableName.bundle`;
    /// or `ExecutableNameTests.bundle` for test resources
    static var module: Bundle = {
        var thisModuleName = "EPUBKit"
        var url = Bundle.main.bundleURL

        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            url = bundle.bundleURL.deletingLastPathComponent()
            thisModuleName = thisModuleName.appending("_EPUBKitTests")
        }

        url = url.appendingPathComponent("\(thisModuleName).bundle")

        guard let bundle = Bundle(url: url) else {
            fatalError("Foundation.Bundle.module could not load resource bundle: \(url.path)")
        }

        return bundle
    }()

    /// Directory containing resource bundle
    static var moduleDir: URL = {
        var url = Bundle.main.bundleURL
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            // remove 'ExecutableNameTests.xctest' path component
            url = bundle.bundleURL.deletingLastPathComponent()
        }
        return url
    }()

}
#endif
