//
//  FoodSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/28/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite : SKSpriteNode {
  public static func newInstance() -> FoodSprite {
    let foodDish = FoodSprite(imageNamed: "food_dish")

    foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
    foodDish.physicsBody?.categoryBitMask = FoodCategory
    foodDish.physicsBody?.contactTestBitMask = WorldCategory | RainDropCategory | CatCategory
    foodDish.zPosition = 5

    return foodDish
  }
}
