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
  private(set) var initiallySetPalatte : Bool

  private(set) var lcdHighScore : Int

  private init() {
    //This is private so you can only have one Sound Manager ever.

    let defaults = UserDefaults.standard

    isMuted = defaults.bool(forKey: MuteKey)
    initiallySetPalatte = defaults.bool(forKey: FirstLaunchPaletteChooser)
    lcdHighScore = defaults.integer(forKey: LCDSinglePlayerScoreKey)

    if !initiallySetPalatte {
      playerOnePalette = 0
      playerTwoPalette = 1

      defaults.set(playerOnePalette, forKey: PlayerOnePaletteKey)
      defaults.set(playerTwoPalette, forKey: PlayerTwoPaletteKey)
      defaults.set(true, forKey: FirstLaunchPaletteChooser)
      defaults.synchronize()
    } else {
      playerOnePalette = defaults.integer(forKey: PlayerOnePaletteKey)
      playerTwoPalette = defaults.integer(forKey: PlayerTwoPaletteKey)
    }
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

  public func toggleMute() -> Bool {
    isMuted = !isMuted

    let defaults = UserDefaults.standard
    defaults.set(isMuted, forKey: MuteKey)
    defaults.synchronize()

    return isMuted
  }

  public func getClassicHighScore() -> Int {
    let defaults = UserDefaults.standard

    return defaults.integer(forKey: ClassicSinglePlayerScoreKey)
  }

  public func updateClassicHighScore(highScore : Int) {
    if highScore > getClassicHighScore() {

      let defaults = UserDefaults.standard
      defaults.set(highScore, forKey: ClassicSinglePlayerScoreKey)
      defaults.synchronize()
    }
  }

  public func getClassicMultiplayerHighScore() -> Int {
    let defaults = UserDefaults.standard

    return defaults.integer(forKey: ClassicMultiplayerScoreKey)
  }

  public func updateClassicMultiplayerHighScore(highScore : Int) {
    if highScore > getClassicMultiplayerHighScore() {
      let defaults = UserDefaults.standard
      defaults.set(highScore, forKey: ClassicMultiplayerScoreKey)
      defaults.synchronize()
    }
  }

  public func getLCDHighScore() -> Int {
    let defaults = UserDefaults.standard

    return defaults.integer(forKey: LCDSinglePlayerScoreKey)
  }

  public func updateLCDHighScore(highScore : Int) {
    lcdHighScore = highScore

    let defaults = UserDefaults.standard
    defaults.set(highScore, forKey: LCDSinglePlayerScoreKey)
    defaults.synchronize()
  }
}
