//
//  RangeReplaceableCollectionType.swift
//  Drone
//
//  Created by BC600 on 16/5/31.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object: Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}



