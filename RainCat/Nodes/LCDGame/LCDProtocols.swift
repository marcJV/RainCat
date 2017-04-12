//
//  Resetable.swift
//  RainCat
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import Foundation

protocol Resetable {
  func resetPressed()
  func resetReleased()
}

protocol LCDUpdateable {
  func update()
}

protocol LCDSetupable {
  func setup()
}
