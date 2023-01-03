//
//  CKConfig.swift
//
//  Created for the CardinalKit framework.
//  Copyright © 2020 CardinalKit. All rights reserved.
//

import Foundation

class CKConfig: CKPropertyReader {
    static let shared = CKPropertyReader(file: "CKConfiguration")
}
