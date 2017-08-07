//
//  EPUBKitDataSourceDelegate.swift
//  EPUBKit
//
//  Created by Witek on 07/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

protocol EPUBViewDataSourceDelegate: class {
    func dataSourceDidFinishBuilding(_ dataSource: EPUBDataSource)
}
