//
//  UIImage+Color.swift
//  O-Home
//
//  Created by BC600 on 15/6/2.
//  Copyright (c) 2015年 ob-home. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func image(color c: UIColor, withSize size: CGSize) ->UIImage! {
        // 使用颜色创建UIImage
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(c.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func getPixelColor(pos:CGPoint) -> UIColor {
        let pixelData = self.cgImage?.dataProvider?.data
        let data = CFDataGetBytePtr(pixelData)!
        let pixelInfo = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let red = CGFloat(data[pixelInfo]) / 255
        let green = CGFloat(data[pixelInfo + 1]) / 255
        let blue = CGFloat(data[pixelInfo + 2]) / 255
        let alpha = CGFloat(data[pixelInfo + 3]) / 255
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
}
