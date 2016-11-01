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

    if let scene = GKScene(fileNamed: "LCDScene") {

      // Get the SKScene from the loaded GKScene
      if let sceneNode = scene.rootNode as! LCDScene? {

        // Copy gameplay related content over to the scene
//        sceneNode.entities = scene.entities
//        sceneNode.graphs = scene.graphs

        // Set the scale mode to scale to fit the window
        sceneNode.scaleMode = .aspectFill

        // Present the scene
        if let view = self.view as! SKView? {
          view.presentScene(sceneNode)

          view.ignoresSiblingOrder = true

          view.showsFPS = true
          view.showsNodeCount = true
        }
      }
    }

/*
    let sceneNode = LogoScene(size: view.frame.size)

    if let view = self.view as! SKView? {
      view.presentScene(sceneNode)
      view.ignoresSiblingOrder = true
      //view.showsPhysics = true
      //view.showsFPS = true
      //view.showsNodeCount = true
    }
*/

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
