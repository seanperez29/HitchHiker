//
//  CenterVCDelegate.swift
//  HitchHiker
//
//  Created by Sean Perez on 6/26/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

protocol CenterVCDelegate {
    func toggleMenu()
    func addMenuViewController()
    func animateMenu(shouldExpand: Bool)
}
