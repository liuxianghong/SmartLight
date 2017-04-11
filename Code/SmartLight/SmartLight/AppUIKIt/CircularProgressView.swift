//
//  MediaDownloadView.swift
//  Drone
//
//  Created by BC600 on 16/3/23.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit
import YYKit

class CircularProgressView: UIView {
    
    var progress = CGFloat(0.0) {
        didSet {
            if progress < 0.0 {progress = 0.0}
            if progress > 1.0 {progress = 1.0}

            CATransaction.begin()
            // 进度值比以前的值小则关不隐式动画显示
            if progress <= oldValue {
                CATransaction.setDisableActions(true)
            } else {
                CATransaction.setDisableActions(false)
            }
            progressForegroundLayer.strokeEnd = progress
            CATransaction.commit()
        }
    }
    
    var lineWidth = CGFloat(1.5) {
        didSet {
            progressBackgroundLayer.lineWidth = lineWidth
            progressForegroundLayer.lineWidth = lineWidth
        }
    }
    
    var strokeColor = UIColor(red: 56.0/255, green: 187.0/255, blue: 1, alpha: 1) {
        didSet {
            progressForegroundLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    fileprivate let progressBackgroundLayer = CAShapeLayer()
    fileprivate let progressForegroundLayer = CAShapeLayer()
    fileprivate let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    fileprivate func initView() {
        
        progressBackgroundLayer.lineWidth = lineWidth
        progressBackgroundLayer.fillColor = UIColor(white: 0, alpha: 0.17).cgColor
        progressBackgroundLayer.strokeColor = UIColor(white: 1, alpha: 0.17).cgColor
        progressBackgroundLayer.strokeEnd = 1.0
        self.layer.addSublayer(progressBackgroundLayer)
        
        progressForegroundLayer.lineWidth = lineWidth
        progressForegroundLayer.fillColor = nil
        progressForegroundLayer.strokeColor = strokeColor.cgColor
        progressForegroundLayer.strokeEnd = 0.0
        self.layer.addSublayer(progressForegroundLayer)
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressBackgroundLayer.frame = bounds
        progressBackgroundLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: width / 2, y: height / 2),
            radius: width / 2,
            startAngle: -90.0 / 180.0 * CGFloat(Double.pi),
            endAngle: 270.0 / 180.0 * CGFloat(Double.pi),
            clockwise: true).cgPath
        
        progressForegroundLayer.frame = bounds
        progressForegroundLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: width / 2, y: height / 2),
            radius: width / 2,
            startAngle: -90.0 / 180.0 * CGFloat(Double.pi),
            endAngle: 270.0 / 180.0 * CGFloat(Double.pi),
            clockwise: true).cgPath
        
        self.layoutIfNeeded()
    }
}
