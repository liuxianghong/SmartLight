//
//  ScrollLabel.swift
//  Drone
//
//  Created by BC600 on 16/10/28.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class ScrollLabel: UIView {
    
    var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return textLabel.textAlignment
        }
        set {
            textLabel.textAlignment = newValue
        }
    }
    
    var font: UIFont! {
        get {
            return textLabel.font
        }
        set {
            textLabel.font = newValue
        }
    }
    
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    
    var numberOfLines: Int {
        get {
            return textLabel.numberOfLines
        }
        set {
            textLabel.numberOfLines = newValue
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return textLabel.attributedText
        }
        set {
            textLabel.attributedText = newValue
        }
    }
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    fileprivate func initView() {
        scrollView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalTo(0)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.clipsToBounds = true
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        
        self.backgroundColor = UIColor.clear
    }
    
}
