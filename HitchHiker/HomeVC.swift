//
//  HomeVC.swift
//  HitchHiker
//
//  Created by Sean Perez on 6/25/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: RoundedShadowButton!
    var delegate: CenterVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func actionButtonPressed(_ sender: Any) {
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        delegate?.toggleMenu()
    }


}

