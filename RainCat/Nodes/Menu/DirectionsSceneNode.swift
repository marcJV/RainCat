//
//  DirectionsNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 6/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class DirectionsSceneNode : SceneNode, SKPhysicsContactDelegate {

  private var backButton : TwoPaneButton!
  private var singleClassicButton : TwoPaneButton!
  private var lcdButton : TwoPaneButton!
  private var multiClassicButton : TwoPaneButton!
  private var catPongButton : TwoPaneButton!

  private var nextButton : TextButtonSprite!
  private var previousButton : TextButtonSprite!

  private var directionsGroup : SKNode!
  private var catPongGroup : InstructionsNode!
  private var lcdGroup : InstructionsNode!
  private var classicSingleGroup : InstructionsNode!
  private var classicMultiGroup : InstructionsNode!

  private var currentNode : SKNode!

  override func layoutScene(size: CGSize, extras: MenuExtras?) {
    var worldFrame = frame
    worldFrame.origin.y -= frame.size.height * 2
    worldFrame.size.height += frame.size.height * 4
    worldFrame.size.width += frame.size.width

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
    self.physicsBody?.categoryBitMask = WorldFrameCategory

    if let gravityManager = parent as? WorldManager {
      gravityManager.updateGravity(vector: CGVector(dx: 0, dy: -2))
    }

    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR
    isUserInteractionEnabled = true

    var scene : SKScene

    if UIDevice.current.userInterfaceIdiom == .phone {
      scene = SKScene(fileNamed: "DirectionsScene")!//Todo make iphone variant
    } else {
      scene = SKScene(fileNamed: "DirectionsScene")!
    }

    for child in scene.children {
      child.removeFromParent()
      addChild(child)

      //Fix position since SKS file's anchorpoint is (0,1)
      child.position.y += size.height
    }

    directionsGroup = childNode(withName: "group-directions-menu")
    catPongGroup = childNode(withName: "group-cat-pong") as! InstructionsNode
    lcdGroup = childNode(withName: "group-lcd") as! InstructionsNode
    classicMultiGroup = childNode(withName: "group-classic-multi") as! InstructionsNode
    classicSingleGroup = childNode(withName: "group-classic-single") as! InstructionsNode

    catPongGroup.position.x = size.width
    lcdGroup.position.x = size.width
    classicMultiGroup.position.x = size.width
    classicSingleGroup.position.x = size.width

    currentNode = directionsGroup

    backButton = childNode(withName: "button-back") as! TwoPaneButton
    backButton.addTarget(self, selector: #selector(backClicked), forControlEvents: .TouchUpInside)

    singleClassicButton = directionsGroup.childNode(withName: "button-single-classic") as! TwoPaneButton
    singleClassicButton.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    lcdButton = directionsGroup.childNode(withName: "button-lcd") as! TwoPaneButton
    lcdButton.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    multiClassicButton = directionsGroup.childNode(withName: "button-multi-classic") as! TwoPaneButton
    multiClassicButton.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    catPongButton = directionsGroup.childNode(withName: "button-cat-pong") as! TwoPaneButton
    catPongButton.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    nextButton = childNode(withName: "button-right") as! TextButtonSprite
    nextButton.set(text: ">", fontSize: 150, autoResize: false)
    nextButton.addTarget(self, selector: #selector(nextButtonClicked), forControlEvents: .TouchUpInside)

    previousButton = childNode(withName: "button-left") as! TextButtonSprite
    previousButton.set(text: "<", fontSize: 150, autoResize: false)
    previousButton.addTarget(self, selector: #selector(previousButtonClicked), forControlEvents: .TouchUpInside)


    updateSideButtons()
  }

  override func attachedToScene() {

  }

  override func detachedFromScene() {

  }

  let spawnRate : TimeInterval = 0.25
  var currentSpawnTime : TimeInterval = 0

  override func update(dt : TimeInterval) {
    currentSpawnTime += dt

    if currentSpawnTime > spawnRate {
      currentSpawnTime = 0

      spawnRaindrop()

      if Int(arc4random_uniform(20)) == 0 {
        spawnCat()
      }

      if Int(arc4random_uniform(50)) == 0 {
        spawnUmbrella()
      }
    }
  }

  func spawnCat() {
    let cat = CatSprite.newInstance()
    cat.position = getSpawnLocation()
    cat.zPosition = 0

    addChild(cat)
  }

  func spawnUmbrella() {
    let umbrella = UmbrellaSprite(palette: ColorManager.sharedInstance.getRandomPalette())
    umbrella.position = getSpawnLocation()
    umbrella.makeDynamic()

    addChild(umbrella)
  }

  func spawnRaindrop() {
    let rainDrop = RainDropSprite(scale: 2)
    rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2)
    rainDrop.addPhysics()
    rainDrop.zPosition = 0

    rainDrop.position = getSpawnLocation()

    rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100

    addChild(rainDrop)
  }

  func getSpawnLocation() -> CGPoint {
    var randomPosition = CGFloat(arc4random())
    randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width)
    return CGPoint(x: randomPosition, y: size.height * 1.5)
  }

  func nextButtonClicked() {
    if let instructionNode = currentNode as? InstructionsNode {
      instructionNode.slideForwards()

      updateSideButtons()
    }
  }

  func previousButtonClicked() {
    if let instructionNode = currentNode as? InstructionsNode {
      instructionNode.slideBackwards()

      updateSideButtons()
    }
  }

  func navigateToScene() {


    if let parent = parent as? Router {
      var location : Location? = nil

      if currentNode == classicSingleGroup {
        location = .Classic
      } else if currentNode == classicMultiGroup {
        location = .ClassicMulti
      } else if currentNode == lcdGroup {
        location = .LCD
      } else if currentNode == catPongGroup {
        location = .CatPong
      }

      if let location = location {
        let extras = MenuExtras(rainScale: 1,
                                catScale: 1,
                                transition: TransitionExtras(transitionType: .ScaleInCircular(fromPoint: CGPoint()),
                                                             toColor: location == .LCD ? .black : RAIN_COLOR))

        parent.navigate(to: location, extras: extras)
      }

    }
  }

  func backClicked() {
    if currentNode == directionsGroup {
      if let parent = (parent as? Router) {
        parent.navigate(to: .MainMenu, extras: MenuExtras(rainScale: 0,
                                                          catScale: 0,
                                                          transition: TransitionExtras(transitionType: .ScaleInLinearTop)))
      }
    } else {
      //show back in menu
      currentNode.run(SKAction.group([
        SKAction.fadeAlpha(to: 0, duration: 0.5),
        SKActionHelper.moveToEaseInOut(x: size.width, duration: 0.55)
        ]))


      directionsGroup.run(SKAction.group([
        SKAction.fadeAlpha(to: 1, duration: 0.5),
        SKActionHelper.moveToEaseInOut(x: 0, duration: 0.55)
        ]))

      if let instructions = currentNode as? InstructionsNode {
        instructions.hideNode()
      }

      currentNode = directionsGroup

      updateSideButtons()
    }
  }

  func directionsButtonClicked(_ sender: TwoPaneButton) {
    if sender == singleClassicButton {
      currentNode = classicSingleGroup
    } else if sender == lcdButton {
      currentNode = lcdGroup
    } else if sender == multiClassicButton {
      currentNode = classicMultiGroup
    } else if sender == catPongButton {
      currentNode = catPongGroup
    }

    (currentNode as! InstructionsNode).showNode()
    currentNode.run(SKAction.group([
      SKAction.fadeAlpha(to: 1, duration: 0.5),
      SKActionHelper.moveToEaseInOut(x: 0, duration: 0.55)
      ]))


    directionsGroup.run(SKAction.group([
      SKAction.fadeAlpha(to: 0, duration: 0.5),
      SKActionHelper.moveToEaseInOut(x: -size.width / 2, duration: 0.55)
      ]))

    updateSideButtons()
  }

  func updateSideButtons() {
    if let instructionNode = currentNode as? InstructionsNode {
      nextButton.alpha = instructionNode.hasNext() ? 1 : 0
      previousButton.alpha = instructionNode.hasPrevious() ? 1 : 0
    } else {
      nextButton.alpha  = 0
      previousButton.alpha = 0
    }
  }

  func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == WorldFrameCategory {
      contact.bodyB.node?.removeFromParent()
    } else {
      contact.bodyA.node?.removeFromParent()
    }
  }
  
  deinit {
    print("directions scene is gone")
  }
}
