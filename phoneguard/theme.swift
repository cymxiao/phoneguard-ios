//
//  theme.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/10/1.
//  Copyright © 2018 蔡亚明. All rights reserved.
//

import Foundation
import UIKit


struct MyTheme {
    
    let foreColor: UIColor
    let backgroundColor: UIColor
    let alarmedImage: UIImage
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
 
