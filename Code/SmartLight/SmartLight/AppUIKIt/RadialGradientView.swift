//
//  RadialGradientView.swift
//  Drone
//
//  Created by BC600 on 16/2/25.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit

class RadialGradientView: PenetrateView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayerMaskImage()
        
        self.layoutIfNeeded()
    }
    
    fileprivate func updateLayerMaskImage() {
        
        // 生成渐变Image
        UIGraphicsBeginImageContext(CGSize(width: bounds.width, height: bounds.height))
        let space = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 0.0, 0.0, 0.6, 1.0, 0.0, 0.0, 0.0]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient =  CGGradient(colorSpace: space, colorComponents: components, locations: locations, count: locations.count)
        let startCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let context = UIGraphicsGetCurrentContext()
        context!.drawRadialGradient(gradient!, startCenter: startCenter, startRadius: 0.0, endCenter: startCenter, endRadius: bounds.width/2, options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 设置遮罩
        let maskLayer = CALayer()
        maskLayer.contents = image?.cgImage
        maskLayer.frame = bounds
        self.layer.mask = maskLayer
    }
    
}
