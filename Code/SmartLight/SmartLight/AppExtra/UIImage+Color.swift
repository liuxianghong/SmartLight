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
    
}
