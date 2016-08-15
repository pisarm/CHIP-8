//
//  View+Animate.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 14/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func animatePush() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.13
        animation.autoreverses = true
        animation.fromValue = 1
        animation.toValue = 0.9

        layer.add(animation, forKey: "push")
    }

    func animateShake() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0.0, 0.17, 0.5, 0.84, 1.0]
        animation.duration = 0.4
        animation.isAdditive = true

        layer.add(animation, forKey: "shake")
    }

}
