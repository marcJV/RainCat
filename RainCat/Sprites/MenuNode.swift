//
//  MenuNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class MenuNode : SKNode {
  private var startButton : TwoPaneButton!
  private var versusButton : TwoPaneButton!

  private let highScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)

  public var startGameAction : (() -> ())?
  public var versusAction : (() -> ())?

  private var selectedButton : SKNode?

  public func setup() {
    //Setup start button
    let appTitleNode = ShadowLabelNode(fontNamed: BASE_FONT_NAME)
    appTitleNode.text = "RainCat"
    appTitleNode.fontSize = 110

    addChild(appTitleNode)

    startButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 300, height: 70))
    startButton.setup(text: "Classic Mode", fontSize: 30)
    startButton.position = CGPoint(x: -startButton.size.width / 2.0, y: appTitleNode.position.y + 15 - appTitleNode.fontSize - startButton.size.height / 2)


    startButton.addTarget(self, selector: #selector(MenuNode.runStartGameAction(_:)), forControlEvents: .TouchUpInside)

    addChild(startButton)

    versusButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 300, height: 70))
    versusButton.setup(text: "Verses Mode", fontSize: 30)
    versusButton.position = CGPoint(x: -startButton.size.width / 2.0, y: startButton.position.y - startButton.size.height / 2 - versusButton.size.height / 2 - 20)
    versusButton.addTarget(self, selector: #selector(MenuNode.runVersesGameAction(_:)), forControlEvents: .TouchUpInside)


    addChild(versusButton)

    //Setup high score node
    let defaults = UserDefaults.standard

    let highScore = defaults.integer(forKey: ScoreKey)

    highScoreNode.text = "\(highScore)"
    highScoreNode.fontSize = 90
    highScoreNode.verticalAlignmentMode = .top
    highScoreNode.position = CGPoint(x: 0, y: startButton.size.height / 2 - 65)
    highScoreNode.zPosition = 1

    addChild(highScoreNode)
  }

  func runStartGameAction(_ sender:Any) {
    startGameAction!()
  }

  func runVersesGameAction(_ sender:Any) {
    versusAction!()
  }

  func clearActions() {
    startGameAction = nil
    versusAction = nil
  }
}
