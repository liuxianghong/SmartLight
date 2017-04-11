//
//  RoundLable.swift
//  SteamGenerator
//
//  Created by BC600 on 15/4/28.
//  Copyright (c) 2015年 Bugfo. All rights reserved.
//

import UIKit
import SnapKit

class RoundLable: UIView {
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }
    
    var font: UIFont! {
        get {
            return label.font
        }
        set {
            label.font = newValue
        }
    }
    
    var textColor: UIColor! {
        get {
            return label.textColor
        }
        set {
            label.textColor = newValue
        }
    }
    
    var inset = UIEdgeInsetsMake(10, 12, 10, 12) {
        didSet {
            label.snp.updateConstraints { (make) -> Void in
                make.edges.equalTo(0).inset(inset)
            }
        }
    }
    
    var numberOfLines: Int {
        get {
            return label.numberOfLines
        }
        set {
            label.numberOfLines = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return label.textAlignment
        }
        set {
            label.textAlignment = newValue
        }
    }
    
    var label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLabel()
    }
    
    fileprivate func initLabel() {
        
        //self.font = R.font.fZLTHJWGB10(size: 15.0)
        self.textColor = UIColor.white
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.isUserInteractionEnabled = false
        self.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(0).inset(inset)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置圆角
        self.cornerRadius = self.bounds.height / 2
    }
    
}



