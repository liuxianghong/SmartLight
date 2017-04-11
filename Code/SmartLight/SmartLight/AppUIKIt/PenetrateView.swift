//
//  PenetrateView.swift
//  Drone
//
//  Created by BC600 on 15/12/29.
//  Copyright © 2015年 Fimi. All rights reserved.
//

import UIKit

class PenetrateView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 让用户可以点击到该view的下方
        guard let view = super.hitTest(point, with: event), view != self else {
            return nil
        }
        
        return view
    }
    
}
