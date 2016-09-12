//
//  FoodSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite : SKSpriteNode, Palettable {
  public static let foodDishName = "FoodDish"

  public static func newInstance(palette : ColorPalette) -> FoodSprite {
    let foodDish = FoodSprite(imageNamed: "food_dish")
    foodDish.name = foodDishName
    foodDish.color = palette.foodBowlColor
    foodDish.colorBlendFactor = 1

    foodDish.anchorPoint = CGPoint(x: 0, y: 1)

    foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size,
                                         center: CGPoint(x: foodDish.size.width / 2, y: -foodDish.size.height / 2))
    foodDish.physicsBody?.categoryBitMask = FoodCategory
    foodDish.physicsBody?.contactTestBitMask = WorldFrameCategory | RainDropCategory | CatCategory
    foodDish.zPosition = 3

    //Generate Food Topping - Currently will always be brown
    let foodHeight = foodDish.size.height * 0.25
    let foodShape = SKShapeNode(rect: CGRect(x: 0, y: -foodHeight, width: foodDish.size.width, height: foodHeight))
    foodShape.fillColor = SKColor(red:0.36, green:0.21, blue:0.08, alpha:1.0)
    foodShape.strokeColor = SKColor.clear
    foodShape.zPosition = 4

    foodDish.addChild(foodShape)

    return foodDish
  }

  public func updatePalette(palette: ColorPalette) {
    run(ColorAction().colorTransitionAction(fromColor: color, toColor: palette.foodBowlColor, duration: colorChangeDuration))
  }
}
