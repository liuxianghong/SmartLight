//
//  SwitchButton.swift
//  Drone
//
//  Created by BC600 on 16/9/22.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class SwitchButton: UIButton {

    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.updataIndicatorView()
            }) 
        }
    }
    
    fileprivate let indicatorView = PenetrateView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    fileprivate func initView() {
        
        self.backgroundColor = UIColor.clear
        self.borderColor = UIColor(white: 0, alpha: 0.2)
        self.borderWidth = 1
        self.cornerRadius = 22 / 2
        self.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 40, height: 22))
        }
        
        indicatorView.backgroundColor = UIColor(white: 237.0/255, alpha: 1)
        indicatorView.borderColor = UIColor(white: 0, alpha: 0.2)
        indicatorView.borderWidth = 1
        indicatorView.cornerRadius = 14 / 2
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        updataIndicatorView()
        
        self.layoutIfNeeded()
    }
    
    fileprivate func updataIndicatorView() {
        if self.isSelected {
            self.indicatorView.left = 22
            self.indicatorView.backgroundColor = UIColor(red: 1, green: 84.0/255, blue: 0, alpha: 1)
        } else {
            self.indicatorView.left = 4
            self.indicatorView.backgroundColor = UIColor(white: 237.0/255, alpha: 1)
        }
    }
}
