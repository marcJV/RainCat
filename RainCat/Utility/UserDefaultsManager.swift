//
//  UserDefaultsManager.swift
//  RainCat
//
//  Created by Marc Vandehey on 4/12/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import Foundation

class UserDefaultsManager {
  static let sharedInstance = UserDefaultsManager()

  private(set) var isMuted : Bool
  private(set) var playerOnePalette : Int
  private(set) var playerTwoPalette : Int

  private init() {
    //This is private so you can only have one Sound Manager ever.

    let defaults = UserDefaults.standard

    isMuted = defaults.bool(forKey: MuteKey)
    playerOnePalette = defaults.integer(forKey: PlayerOnePaletteKey)
    playerTwoPalette = defaults.integer(forKey: PlayerTwoPaletteKey)
  }

  public func updatePlayerOnePalette(palette : Int) {
    playerOnePalette = palette

    let defaults = UserDefaults.standard
    defaults.set(palette, forKey: PlayerOnePaletteKey)
    defaults.synchronize()
  }

  public func updatePlayerTwoPalette(palette : Int) {
    playerTwoPalette = palette

    let defaults = UserDefaults.standard
    defaults.set(palette, forKey: PlayerTwoPaletteKey)
    defaults.synchronize()
  }

  public func toggleMute() {
    isMuted = !isMuted

    let defaults = UserDefaults.standard
    defaults.set(isMuted, forKey: MuteKey)
    defaults.synchronize()
  }
}
