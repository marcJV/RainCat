//
//  Constants.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/30/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

let RainDropCategory   : UInt32 = 0x1 << 1
let FloorCategory      : UInt32 = 0x1 << 2
let UmbrellaCategory   : UInt32 = 0x1 << 3
let WorldFrameCategory : UInt32 = 0x1 << 4
let CatCategory        : UInt32 = 0x1 << 5
let FoodCategory       : UInt32 = 0x1 << 6

let colorChangeDuration : TimeInterval = 0.25

let LCD_MAX_LOCATION : UInt32 = 6

let lcdOffAlpha : CGFloat = 0.05
let lcdOnAlpha  : CGFloat = 1

let ClassicSinglePlayerScoreKey = "RAINCAT_HIGHSCORE"
let ClassicMultiplayerScoreKey = "RAINCAT_MULTIPLAYER_HIGHSCORE"
let LCDSinglePlayerScoreKey = "RAINCAT_LCD_HIGHSCORE"

let MuteKey = "RAINCAT_MUTED"
let FirstLaunchPaletteChooser = "FIRST_LAUNCH_PALETTE_CHOOSER"
let PlayerOnePaletteKey = "PLAYER_ONE_PALETTE"
let PlayerTwoPaletteKey = "PLAYER_TWO_PALETTE"

let BASE_FONT_NAME = "PixelDigivolve"

public func Distance(p1: CGPoint, p2: CGPoint, absoluteValue: Bool = true) -> CGFloat {
  let distance = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))

  return (absoluteValue ? abs(distance) : distance)
}


public func getDisplaySize() -> CGSize {
  if UIDevice.current.userInterfaceIdiom == .phone {
    return CGSize(width: 1334, height: 750)
  } else {
    return CGSize(width: 1024, height: 768)
  }
}
