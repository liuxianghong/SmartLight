//
//  LoadingView.swift
//  Drone
//
//  Created by BC600 on 16/1/19.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    fileprivate var delayHideTimer: Timer?
    fileprivate var isShow = true
    fileprivate var activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    deinit {
    }
    
    fileprivate func initView() {
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        self.addSubview(activity)
        activity.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
        show(false)
    }
    
    func show(_ animated: Bool) {
        
        delayHideTimer?.invalidate()
        delayHideTimer = nil
        
        guard !isShow else {return}
        
        isShow = true
        
        self.activity.startAnimating()
        
        superview?.bringSubview(toFront: self)
        alpha = 0
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1
        }) 
    }
    
    func hide(_ animated: Bool) {
        
        delayHideTimer?.invalidate()
        delayHideTimer = nil
        
        isShow = false
        
        UIView.animate(
            withDuration: animated ? 0.3 : 0,
            animations: { () -> Void in
                self.alpha = 0
            },
            completion: { (finished) -> Void in
                // 隐藏中才需要停止动画
                if !self.isShow {
                    self.activity.stopAnimating()
                }
            }
        )
    }
    
    func hide(_ animated: Bool, afterDelay delay: Foundation.TimeInterval) {
        delayHideTimer?.invalidate()
        delayHideTimer = Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(delayHideTimerTimeout(_:)),
            userInfo: ["animated": animated],
            repeats: false
        )
    }
    
    func delayHideTimerTimeout(_ sender: Timer) {
        
        guard let animated = (sender.userInfo as? [String: Any])?["animated"] as? Bool else {
            return
        }
        
        hide(animated)
    }
}
