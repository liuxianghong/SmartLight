//
//  ToastView.swift
//  Drone
//
//  Created by BC600 on 16/1/18.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class ToastView: RoundLable {
    
    var removeFromSuperViewOnHide = false
    
    fileprivate var delayHideTimer: Timer?
    fileprivate var isShow = true
    
    func show(_ animated: Bool) {
        
        delayHideTimer?.invalidate()
        delayHideTimer = nil
        
        guard !isShow else {return}
        
        isShow = true
        
        superview?.bringSubview(toFront: self)
        alpha = 0.0
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1.0
        }) 
    }
    
    func hide(_ animated: Bool) {
        
        delayHideTimer?.invalidate()
        delayHideTimer = nil
        
        isShow = false
        
        UIView.animate(withDuration: animated ? 0.3 : 0
            , animations: { () -> Void in
                self.alpha = 0
            }
            , completion: { (finished) -> Void in
                // 隐藏中从父视图删除
                if !self.isShow && self.removeFromSuperViewOnHide {
                    self.removeFromSuperview()
                }
            }
        )
    }
    
    func hide(_ animated: Bool, afterDelay delay: Foundation.TimeInterval) {
        delayHideTimer?.invalidate()
        delayHideTimer = Timer.scheduledTimer(timeInterval: delay
            , target: self
            , selector: #selector(delayHideTimerTimeout(_:))
            , userInfo: ["animated": animated]
            , repeats: false
        )
    }
    
    func delayHideTimerTimeout(_ sender: Timer) {
        
        guard let animated = (sender.userInfo as? [String: Any])?["animated"] as? Bool else {
            return
        }
        
        hide(animated)
    }
}
