//
//  MessageBoxView.swift
//  Drone
//
//  Created by BC600 on 16/4/16.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class MessageBoxView: UIView {
    
    class Item {
        var title = ""
        var font = UIFont.systemFont(ofSize: 15)//R.font.fZLTHJWGB10(size: 15)
        var normalColor = UIColor(white: 0, alpha: 1.0)
        var highlightedColor = UIColor(white: 0, alpha: 0.5)
        var action: ((MessageBoxView, UIButton) -> Void)?
    }
    
    fileprivate var titleText = ""
    fileprivate var titleView: UIView!
    fileprivate var customizeView: UIView?
    fileprivate var buttons = [Item]()
    fileprivate let contentView = UIView()
    fileprivate let boxView = UIView()
    fileprivate let buttonBoxView = UIView()
    
    @discardableResult
    class func showViewAddedTo(_ view: UIView
        , animated: Bool
        , titleText: String = ""
        , titleView: UIView? = nil
        , customizeView: UIView? = nil
        , buttons: [Item]
        , completion: ((Bool) -> Void)? = nil)
        -> MessageBoxView
    {
        let messageBoxView = MessageBoxView()
        messageBoxView.titleText = titleText
        messageBoxView.titleView = titleView
        messageBoxView.customizeView = customizeView
        messageBoxView.buttons = buttons
        messageBoxView.setupView()
        view.addSubview(messageBoxView)
        messageBoxView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        
        messageBoxView.alpha = 0
        UIView.animate(withDuration: animated ? 0.3 : 0
            , animations: {
                messageBoxView.alpha = 1
            }
            , completion: { (finished) -> Void in
                completion?(finished)
            }
        )

        return messageBoxView
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    fileprivate func setupView() {
        
        setupContentView()
        setupTitleView()
        setupCustomizeView()
        setupButtonBoxView()
        
        backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    fileprivate func setupContentView() {
        contentView.backgroundColor = UIColor(white: 247.0/255, alpha: 1)
        contentView.cornerRadius = 4
        contentView.clipsToBounds = true
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(self.snp.width).multipliedBy(2 / 3.0)
        }
        
        boxView.backgroundColor = UIColor.clear
        contentView.addSubview(boxView)
        boxView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(0).inset(24)
        }
    }
    
    fileprivate func setupTitleView() {
        
        if titleView == nil {
            let titleLabel = UILabel()
            titleLabel.text = titleText
            //titleLabel.font = R.font.fZLTHJWGB10(size: 15)
            titleLabel.textColor = UIColor.black
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleView = titleLabel
        }
        boxView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.right.lessThanOrEqualTo(0)
        }
    }
    
    fileprivate func setupCustomizeView() {
        if let customizeView = customizeView {
            boxView.addSubview(customizeView)
            customizeView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(titleView.snp.bottom).offset(12)
                make.centerX.equalToSuperview()
                make.left.greaterThanOrEqualTo(0)
                make.right.lessThanOrEqualTo(0)
                make.bottom.equalTo(0).offset(-12)
            }
        } else {
            titleView.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(0).offset(-24)
            }
        }
    }
    
    fileprivate func setupButtonBoxView() {
        
        let splitView = UIView()
        splitView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        contentView.addSubview(splitView)
        splitView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(boxView.snp.bottom)
            make.height.equalTo(0.5)
            make.left.right.equalTo(0)
        }
        
        buttonBoxView.backgroundColor = UIColor(white: 242.0/255, alpha: 1)
        contentView.addSubview(buttonBoxView)
        buttonBoxView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(splitView.snp.bottom)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(52)
        }
        
        // 添加Button
        var firstButton: UIButton?
        for (index, value) in buttons.enumerated() {
            let button = UIButton()
            button.backgroundColor = UIColor.clear
            button.tag = index
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.setTitle(value.title, for: UIControlState())
            button.setTitleColor(value.normalColor, for: UIControlState())
            button.setTitleColor(value.highlightedColor, for: .highlighted)
            button.titleLabel?.font = value.font
            buttonBoxView.addSubview(button)
            button.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(0)
            }
            
            // 判断是否是第一个
            if let firstButton = firstButton {
                let splitView = UIView()
                splitView.backgroundColor = UIColor(white: 0, alpha: 0.2)
                buttonBoxView.addSubview(splitView)
                splitView.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(firstButton.snp.right)
                    make.top.bottom.equalTo(0)
                    make.width.equalTo(0.5)
                }
                
                button.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(splitView.snp.right)
                    make.width.equalTo(firstButton.snp.width)
                    if buttons.count == 1 {
                        make.width.greaterThanOrEqualTo(344)
                    } else {
                        make.width.greaterThanOrEqualTo(172)
                    }
                }
            } else {
                button.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(0)
                    if buttons.count == 1 {
                        make.width.greaterThanOrEqualTo(344)
                    } else {
                        make.width.greaterThanOrEqualTo(172)
                    }
                }
            }
            firstButton = button
            
            // 判断是否是最后一个
            if index == buttons.count - 1 {
                button.snp.makeConstraints { (make) -> Void in
                    make.right.equalTo(0)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scale = UIScreen.main.bounds.width / (1920.0 / 3)
        contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        self.layoutIfNeeded()
    }
    
    func buttonPressed(_ sender: UIButton) {
        if sender.tag < buttons.count {
            buttons[sender.tag].action?(self, sender)
        }
    }
    
    func hideView(_ animated: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: animated ? 0.3 : 0
            , animations: { () -> Void in
                self.alpha = 0
            }
            , completion: { (finished) -> Void in
                self.removeFromSuperview()
                completion?(finished)
            }
        )
    }
}
