//
//  RoundedShadowButton.swift
//  HitchHiker
//
//  Created by Sean Perez on 6/26/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {
    
    var originalSize: CGRect?
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        originalSize = frame
        layer.cornerRadius = 5.0
        layer.shadowRadius = 10.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
    }
    
    func animateButton(shouldLoad: Bool, withMessage message: String?) {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = UIColor.darkGray
        spinner.alpha = 0
        spinner.hidesWhenStopped = true
        spinner.accessibilityIdentifier = "spinner"
        if shouldLoad {
            self.addSubview(spinner)
            setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2, animations: { 
                self.layer.cornerRadius = self.frame.size.height / 2
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
            }, completion: { _ in
                spinner.startAnimating()
                spinner.center = CGPoint(x: self.frame.width / 2 + 1, y: self.frame.width / 2 + 1)
                UIView.animate(withDuration: 0.2, animations: { 
                    spinner.alpha = 1.0
                })
            })
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
            for subview in self.subviews {
                if subview.accessibilityIdentifier == "spinner" {
                    subview.removeFromSuperview()
                }
            }
            UIView.animate(withDuration: 0.2, animations: { 
                self.layer.cornerRadius = 5
                self.frame = self.originalSize!
                self.setTitle(message, for: .normal)
            })
        }
    }

}
