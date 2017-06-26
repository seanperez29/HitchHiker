//
//  CircleView.swift
//  HitchHiker
//
//  Created by Sean Perez on 6/26/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
@IBDesignable

class CircleView: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        layer.cornerRadius = self.frame.width / 2
        layer.borderWidth = 1.5
        layer.borderColor = borderColor?.cgColor
    }

}
