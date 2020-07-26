//
//  ShadowViewHelper.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 02/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setShadowView(to view: UIView) {
        view.layer.masksToBounds = false

        let darkShadow = CALayer()
        darkShadow.frame = view.frame
        darkShadow.frame.origin = CGPoint(x: 0, y: 0)
        darkShadow.cornerRadius = 10
        darkShadow.backgroundColor = Colors.orange
        darkShadow.shadowColor = Colors.darkShadow
        darkShadow.shadowOpacity = 1
        darkShadow.shadowOffset = CGSize(width: 2, height: 2)
        darkShadow.shadowRadius = 2
        
        view.layer.insertSublayer(darkShadow, at: 0)
        
        let lightShadow = CALayer()
        lightShadow.frame = view.frame
        lightShadow.frame.origin = CGPoint(x: 0, y: 0)
        lightShadow.cornerRadius = 10
        lightShadow.backgroundColor = Colors.orange
        lightShadow.shadowColor = Colors.lightShadow
        lightShadow.shadowOpacity = 1
        lightShadow.shadowOffset = CGSize(width: -2, height: -2)
        lightShadow.shadowRadius = 2

        view.layer.insertSublayer(lightShadow, at: 0)
    }
}

struct Colors {
    static var backgroundViewColor: CGColor { return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) }
    static var orange: CGColor { return #colorLiteral(red: 1, green: 0.6285530822, blue: 0.2953767123, alpha: 1) }
    static var darkShadow: CGColor { return #colorLiteral(red: 1, green: 0.4431372549, blue: 0.2862745098, alpha: 1) }
    static var lightShadow: CGColor { return #colorLiteral(red: 1, green: 0.868552012, blue: 0, alpha: 1) }
    static var textColor: CGColor { return #colorLiteral(red: 0.6398849487, green: 0.2614251673, blue: 0.05647522956, alpha: 1) }
}
