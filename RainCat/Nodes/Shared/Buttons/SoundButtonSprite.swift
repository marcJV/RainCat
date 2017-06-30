//
//  SoundButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class SoundButtonSprite : SKSpriteNode {
  private let base = SKSpriteNode(imageNamed: "speaker-base")
  private let low = SKSpriteNode(imageNamed: "speaker-low")
  private let medium = SKSpriteNode(imageNamed: "speaker-medium")
  private let high = SKSpriteNode(imageNamed: "speaker-high")

  private var soundOn = true

  init(size: CGSize) {
    super.init(texture: nil, color: .clear, size: size)

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup()
  }

  func setMuted() {
    low.run(SKAction.moveTo(x: -size.width / 7, duration: 0.03))
    medium.run(SKAction.moveTo(x: -size.width / 6, duration: 0.07))
    high.run(SKAction.moveTo(x: -size.width / 5, duration: 0.12))
  }

  func setPlaying() {
    low.run(SKAction.moveTo(x: 0, duration: 0.03))
    medium.run(SKAction.moveTo(x: 0, duration: 0.1))
    high.run(SKAction.moveTo(x: 0, duration: 0.15))
  }

  func setPressed() {
    let action = SKAction.scale(to: 1, duration: 0.15)

    base.run(action)
    low.run(action)
    medium.run(action)
    high.run(action)
  }

  func setReleased(toggleState : Bool) {
    let action = SKAction.scale(to: 0.75, duration: 0.15)

    base.run(action)
    low.run(action)
    medium.run(action)
    high.run(action)

    if toggleState {
      soundOn = !soundOn

      if soundOn {
        setPlaying()
      } else {
        setMuted()
      }
    }
  }

  private func setup() {
    base.zPosition = 0

    base.setScale(0.75)
    low.setScale(0.75)
    medium.setScale(0.75)
    high.setScale(0.75)

    addChild(base)
    addChild(low)
    addChild(medium)
    addChild(high)
  }
}
