//
//  EPUBLibrary.swift
//  EPUBKit-iOS
//
//  Created by Witek Bobrowski on 01/07/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

protocol FileLibrary {
    func path(for file: EPUBFile) -> URL
}

class EPUBLibrary: FileLibrary {

    private lazy var bundle: Bundle = {
        return Bundle(for: type(of: self))
    }()

    func path(for file: EPUBFile) -> URL {
        return bundle.resourceURL!.appendingPathComponent(file.fullName)
    }

}
