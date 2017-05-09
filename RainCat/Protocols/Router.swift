//
//  Router.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import Foundation

protocol Router {
  func navigate(to: Location)
}

public enum Location {
  case Logo, MainMenu, Classic, LCD, ClassicMulti, CatPont
}
