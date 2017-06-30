//
//  ColorManager.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/10/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//
//  Various utilities to pull color palettes from a plist and parse them into SKColors

import SpriteKit

let BACKGROUND_COLOR = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)
let RAIN_COLOR = SKColor(red:0.60, green:0.93, blue:1.00, alpha:1.0)

class ColorManager {
  static let sharedInstance = ColorManager()

  private var colorIndex = 0
  private var colorList = [ColorPalette]()

  private init() {
    //This is private so you can only have one Color Manager ever.
    if let path = Bundle.main.path(forResource: "ColorPalette", ofType: "plist") {
      let palettes = NSArray(contentsOfFile: path)

      if let palettes = palettes {
        for palette in palettes {
          let colorStruct = ColorPalette(dictionary: palette as! NSDictionary)
          colorList.append(colorStruct)
        }
      }
    }
  }

  public func resetPaletteIndex() -> ColorPalette {
    colorIndex = 0

    return getNextColorPalette()
  }

  public func getNextColorPalette() -> ColorPalette {
    let palette = colorList[colorIndex]
    colorIndex = (colorIndex + 1) % colorList.count

    return palette
  }

  public func getColorPalette(_ index : Int) -> ColorPalette {
    let fixedIndex = index % colorList.count

    let palette = colorList[fixedIndex]

    print("getting palette number: \(index) \(fixedIndex)")

    return palette
  }

  public func getNextColorPaletteIndex(_ index : Int) -> Int {
    return (index + 1) % colorList.count
  }

  public func getRandomPalette() -> ColorPalette {
    let index = Int(arc4random_uniform(UInt32(colorList.count)))

    return colorList[index]
  }
}

public struct ColorPalette {
  let umbrellaTopColor : SKColor
  let umbrellaBottomColor : SKColor
  let groundColor : SKColor
  let skyColor : SKColor
  let foodBowlColor : SKColor

  init(dictionary : NSDictionary) {
    umbrellaTopColor = SKColor(dictionary["umbrellaTop"]! as! String)
    umbrellaBottomColor = SKColor(dictionary["umbrellaBottom"]! as! String)
    groundColor = SKColor(dictionary["ground"]! as! String)
    skyColor = SKColor(dictionary["sky"]! as! String)
    foodBowlColor = SKColor(dictionary["foodBowl"]! as! String)
  }
}

extension SKColor {
  convenience init(_ hexString: String) {
    let hex = hexString

    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
}
