//
//  Extensions+String.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 7/20/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    var removingAllWhitespace: Self {
        return filter { !$0.isWhitespace }
    }
    mutating func removeAllWhitespace() {
        removeAll { $0.isWhitespace }
    }
}
