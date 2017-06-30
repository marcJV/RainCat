//
//  GameViewController.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    var sceneNode : SKScene //= LogoScene(size: view.frame.size)
//    if UIDevice.current.userInterfaceIdiom == .phone {
//      sceneNode = SKScene(fileNamed: "LogoScene-iPhone")!
//    } else {
      sceneNode = RainCatScene(size: getDisplaySize())
//    }

    if let view = self.view as! SKView? {
      view.presentScene(sceneNode)
      view.ignoresSiblingOrder = true
//      view.scene?.scaleMode = .aspectFill
//      view.showsPhysics = true
      //view.showsFPS = true
      //view.showsNodeCount = true
    }

    SoundManager.sharedInstance.startPlaying()
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
