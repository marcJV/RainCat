//
//  MenuScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene, SKPhysicsContactDelegate {
  let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
  let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")

  let catSprite = CatSprite.newInstance()
  var soundButton : SKSpriteNode! = nil
  var creditsButton = SKLabelNode(fontNamed: "PixelDigivolve")

  var selectedButton : SKNode?

  let creditsNode = CreditsNode()
  let menuNode = MenuNode()
  let playerSelectNode = PlayerSelectNode()

  let rainDropBanner = RainDropBanner()

  var currentNode : Touchable?

  private var showingPlayerSelectScreen = false

  override func sceneDidLoad() {
    backgroundColor = BACKGROUND_COLOR
    let edgeMargin : CGFloat = 25
    let bannerHeight : CGFloat = 100

    rainDropBanner.setup(size: CGSize(width: frame.width, height: bannerHeight))
    rainDropBanner.position = CGPoint(x: 0, y: size.height - bannerHeight - edgeMargin * 2)
    addChild(rainDropBanner)

    currentNode = menuNode

    //Menu Setup
    menuNode.position = CGPoint(x: frame.midX, y: rainDropBanner.position.y - bannerHeight - edgeMargin * 2)
    menuNode.setup()
    addChild(menuNode)

    playerSelectNode.setup(width: frame.width)
    playerSelectNode.alpha = 0
    playerSelectNode.position = CGPoint(x: frame.maxX, y: rainDropBanner.position.y - bannerHeight - edgeMargin * 2)
    addChild(playerSelectNode)

    //Setup sound button
    soundButton = SKSpriteNode(texture: (SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture))
    soundButton.position = CGPoint(x: size.width - edgeMargin,
                                   y: edgeMargin)
    addChild(soundButton)

    //Add in floor physics body
    physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 20), to: CGPoint(x: size.width, y: 20))
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
    physicsBody?.restitution = 0.3

    physicsWorld.contactDelegate = self

    creditsButton = SKLabelNode(fontNamed: "PixelDigivolve")
    creditsButton.text = "?"
    creditsButton.verticalAlignmentMode = .center
    creditsButton.horizontalAlignmentMode = .center

    creditsButton.position = CGPoint(x: edgeMargin, y: edgeMargin)
    addChild(creditsButton)

    creditsNode.position = CGPoint(x: frame.midX, y: size.height / 2 + 100)
    creditsNode.setup()

    addChild(creditsNode)

    catSprite.position = menuNode.position
    addChild(catSprite)

    menuNode.startGameAction = {
      self.handleStartButtonClick()
    }

    menuNode.versesAction = {
      self.handleVersesButtonClick()
    }

    playerSelectNode.backAction = {
      self.handleBackButtonClick()
    }

    playerSelectNode.startAction = {
      self.handleStartVerses()
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      currentNode?.touchBeganAtPoint(touch: touch)

      if creditsButton.contains(touch.location(in: self)) {
        selectedButton = creditsButton
        creditsButton.alpha = 0.75
      } else if soundButton.contains(touch.location(in: self)) {
        selectedButton = soundButton
        handleSoundButtonHover(isHovering: true)
      } else if catSprite.contains(touch.location(in: self)) {
        catSprite.meow()

        switch catSprite.xScale {
        case 1:
          catSprite.setScale(2)
        case 2:
          catSprite.setScale(3)
        case 0...1:
          catSprite.setScale(1)
        default:
          catSprite.setScale(0.5)
        }
      } else {
        rainDropBanner.touchBeganAtPoint(touch: touch)
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {

      currentNode?.touchMovedToPoint(touch: touch)

      if selectedButton == soundButton {
        handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
        //      } else if selectedButton == soundCreditNode {
        //        soundCreditNode.alpha = (soundCreditNode.contains(touch.location(in: self))) ? 0.75 : 1.0
      }else if selectedButton == creditsButton {
        creditsButton.alpha = (creditsButton.contains(touch.location(in: self))) ? 0.75 : 1.0
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {

      currentNode?.touchEndedAtPoint(touch: touch)

      if selectedButton == soundButton {
        handleSoundButtonHover(isHovering: false)

        if (soundButton.contains(touch.location(in: self))) {
          handleSoundButtonClick()
        }
      } else if selectedButton == creditsButton {
        creditsButton.alpha = 1

        handleCreditsButtonClick()
      }
    }

    selectedButton = nil
  }

  func handleSoundButtonHover(isHovering : Bool) {
    if isHovering {
      soundButton.alpha = 0.5
    } else {
      soundButton.alpha = 1.0
    }
  }

  func handleStartButtonClick() {
   rainDropBanner.makeItRain()
  }

  func handleVersesButtonClick() {
    showingPlayerSelectScreen = true
    currentNode = playerSelectNode

    playerSelectNode.position.x = frame.maxX

    let translateAction = SKAction.moveBy(x: -frame.width, y: 0, duration: 0.25)
    menuNode.run(translateAction)
    playerSelectNode.run(translateAction)

    menuNode.run(SKAction.fadeOut(withDuration: 0.25))
    playerSelectNode.run(SKAction.fadeIn(withDuration: 0.25))
  }

  func handleBackButtonClick() {
    showingPlayerSelectScreen = false
    currentNode = menuNode

    let translateAction = SKAction.moveBy(x: frame.width, y: 0, duration: 0.25)
    menuNode.run(translateAction)
    playerSelectNode.run(translateAction)

    menuNode.run(SKAction.fadeIn(withDuration: 0.25))
    playerSelectNode.run(SKAction.fadeOut(withDuration: 0.25))
  }

  func handleStartVerses() {
    rainDropBanner.makeItRain()
  }

  func handleSoundButtonClick() {
    if SoundManager.sharedInstance.toggleMute() {
      //Is muted
      soundButton.texture = soundButtonTextureOff
    } else {
      //Is not muted
      soundButton.texture = soundButtonTexture
    }
  }

  func handleCreditsButtonClick() {
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.25)
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)

    if (currentNode as! SKNode) != creditsNode {
      menuNode.run(fadeOut)
      playerSelectNode.run(fadeOut)

      creditsNode.run(fadeIn)

      currentNode = creditsNode
    } else {
      creditsNode.run(fadeOut)
      menuNode.run(fadeIn)
      playerSelectNode.run(fadeIn)

      currentNode = showingPlayerSelectScreen ? playerSelectNode : menuNode
    }
  }

  var didContact = false
  func didBegin(_ contact: SKPhysicsContact) {

    var rainContact = false
    var rainScale : CGFloat = 1
    if contact.bodyA.categoryBitMask == RainDropCategory {
      rainScale = (contact.bodyA.node?.xScale)!
      rainContact = true
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
      rainScale = (contact.bodyB.node?.xScale)!
      rainContact = true
    }

    if !didContact && rainContact {
      didContact = true

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false

        var scene : SKScene

        if (self.currentNode as! SKNode) == self.menuNode {
          scene = GameScene(size: self.size, catScale: self.catSprite.xScale, rainScale: rainScale)
        } else {
          scene = PingPongScene(size: self.size,
                                player1ColorPalette: self.playerSelectNode.playerOnePalette(),
                                player2ColorPalette: self.playerSelectNode.playerTwoPalette(),
                                catScale: self.catSprite.xScale,
                                rainScale: rainScale)
        }
        
        scene.scaleMode = self.scaleMode
        
        self.view?.presentScene(scene, transition: transition)
      }
    }
  }
  
  deinit {
    print("menu scene destroyed")
  }
}
