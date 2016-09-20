//
//  CreditsNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CreditsNode : SKNode, Touchable {
  var soundCreditNode = SKLabelNode(fontNamed: "PixelDigivolve")
  let t23Logo = SKSpriteNode(imageNamed: "Logo_00089")
  let developer = SKLabelNode(fontNamed: "PixelDigivolve")
  let designCathryn = SKLabelNode(fontNamed: "PixelDigivolve")
  let designMorgan = SKLabelNode(fontNamed: "PixelDigivolve")
  let designLaura = SKLabelNode(fontNamed: "PixelDigivolve")

  private var selectedNode : SKNode?
  public func setup() {
    let creditsColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)

    let developerTitle = ShadowLabelNode(fontNamed: "PixelDigivolve")
    developerTitle.text = "development:"
    developerTitle.horizontalAlignmentMode = .center

    developer.text = "Marc Vandehey"
    developer.horizontalAlignmentMode = .center

    let designerTitle = ShadowLabelNode(fontNamed: "PixelDigivolve")
    designerTitle.text = "design:"
    designerTitle.horizontalAlignmentMode = .center

    designCathryn.text = "Cathryn Rowe"
    designCathryn.horizontalAlignmentMode = .center

    designMorgan.text = "Morgan Wheaton"
    designMorgan.horizontalAlignmentMode = .center

    designLaura.text = "Laura Levisay"
    designLaura.horizontalAlignmentMode = .center

    let soundTitle = ShadowLabelNode(fontNamed: "PixelDigivolve")
    soundTitle.text = "MUSIC:"
    soundTitle.horizontalAlignmentMode = .center

    soundCreditNode.text = "Bensound.com"
    soundCreditNode.horizontalAlignmentMode = .center

    let sectionMargin : CGFloat = 30

    t23Logo.position.y += sectionMargin * 2
    developerTitle.position = CGPoint(x: 0, y: -t23Logo.size.height / 2  + sectionMargin)
    developer.position = CGPoint(x: 0, y: developerTitle.position.y - developerTitle.fontSize)

    designerTitle.position = CGPoint(x: 0, y: developer.position.y - developer.fontSize - sectionMargin)
    designCathryn.position = CGPoint(x: 0, y: designerTitle.position.y - designerTitle.fontSize)
    designMorgan.position = CGPoint(x: 0, y: designCathryn.position.y - designCathryn.fontSize)
    designLaura.position = CGPoint(x: 0, y: designMorgan.position.y - designMorgan.fontSize)

    soundTitle.position = CGPoint(x: 0, y: designLaura.position.y - designLaura.fontSize - sectionMargin)
    soundCreditNode.position = CGPoint(x: 0, y: soundTitle.position.y - soundTitle.fontSize)

    developer.fontColor = creditsColor
    designCathryn.fontColor = creditsColor
    designMorgan.fontColor = creditsColor
    designLaura.fontColor = creditsColor
    soundCreditNode.fontColor = creditsColor

    addChild(t23Logo)
    addChild(developerTitle)
    addChild(developer)
    addChild(designerTitle)
    addChild(designCathryn)
    addChild(designMorgan)
    addChild(designLaura)
    addChild(soundTitle)
    addChild(soundCreditNode)

    zPosition = 1000

    alpha = 0
  }

  public func touchBeganAtPoint(touch: UITouch) {
    if selectedNode == nil {
      let location = touch.location(in: self)

      handleAlpha(node: t23Logo, highlighted: false)
      handleAlpha(node: developer, highlighted: false)
      handleAlpha(node: designCathryn, highlighted: false)
      handleAlpha(node: designMorgan, highlighted: false)
      handleAlpha(node: designLaura, highlighted: false)
      handleAlpha(node: soundCreditNode, highlighted: false)

      if t23Logo.contains(location) {
        selectedNode = t23Logo
      } else if developer.contains(location) {
        selectedNode = developer
      } else if designCathryn.contains(location) {
        selectedNode = designCathryn
      } else if designMorgan.contains(location) {
        selectedNode = designMorgan
      } else if designLaura.contains(location) {
        selectedNode = designLaura
      } else if soundCreditNode.contains(location) {
        selectedNode = soundCreditNode
      }

      if let node = selectedNode {
        handleAlpha(node: node, highlighted: true)
      }
    }
  }

  public func touchMovedToPoint(touch: UITouch) {
    if let node = selectedNode {
      handleAlpha(node: node, highlighted: node.contains(touch.location(in: self)))
    }
  }

  public func touchEndedAtPoint(touch: UITouch) {
    if let node = selectedNode {
      handleAlpha(node: node, highlighted: false)

      var urlString : String?

      if node.contains(touch.location(in: self)) {
        if node == t23Logo {
          urlString = "https://www.thirteen23.com/"
        } else if node == developer {
          urlString = "https://twitter.com/MarcVandehey"
        } else if node == designCathryn {
          urlString = "http://www.cathrynrowe.com/"
        } else if node == designMorgan {
          urlString = "https://twitter.com/morganwheaton"
        } else if node == designLaura {
          urlString = "https://dribbble.com/lauralevisay"
        } else if node == soundCreditNode {
         urlString = "http://www.bensound.com/"
        }
      }

      if let string = urlString, let url = URL(string: string) {
        UIApplication.shared.open(url, options: [:], completionHandler: { (completion) in
          // dont do anything with this currently
        })
      }
    }

    selectedNode = nil
  }

  public func touchCancelledAtPoint(touch: UITouch) {
    handleAlpha(node: t23Logo, highlighted: false)
    handleAlpha(node: developer, highlighted: false)
    handleAlpha(node: designCathryn, highlighted: false)
    handleAlpha(node: designMorgan, highlighted: false)
    handleAlpha(node: designLaura, highlighted: false)
    handleAlpha(node: soundCreditNode, highlighted: false)

    selectedNode = nil
  }

  func handleAlpha(node : SKNode, highlighted : Bool) {
    if highlighted {
      node.run(SKAction.fadeAlpha(to: 0.75, duration: 0.15))
    } else {
      node.run(SKAction.fadeAlpha(to: 1.0, duration: 0.15))
    }
  }
}
