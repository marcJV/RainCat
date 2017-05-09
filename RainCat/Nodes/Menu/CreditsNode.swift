//
//  CreditsNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CreditsNode : SKNode {
  weak var menuNavigation : MenuNavigation?

  func setup(navigation : MenuNavigation) {
    menuNavigation = navigation

    let marcButton = childNode(withName: "button-marc") as! CreditLabelButtonSprite
    marcButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let jeffButton = childNode(withName: "button-jeff") as! CreditLabelButtonSprite
    jeffButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let bensoundButton = childNode(withName: "button-bensound") as! CreditLabelButtonSprite
    bensoundButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let cathrynButton = childNode(withName: "button-cathryn") as! CreditLabelButtonSprite
    cathrynButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let morganButton = childNode(withName: "button-morgan") as! CreditLabelButtonSprite
    morganButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let lauraButton = childNode(withName: "button-laura") as! CreditLabelButtonSprite
    lauraButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    let logoButton = childNode(withName: "button-logo") as! LogoButtonSprite
    logoButton.addTarget(self, selector: #selector(logoClicked(_:)), forControlEvents: .TouchUpInside)
  }

  func creditButtonClicked(_ sender : CreditLabelButtonSprite) {
    menuNavigation?.navigateToUrl(url: sender.getUrl()!)
  }

  func logoClicked(_ sender : LogoButtonSprite) {
    menuNavigation?.navigateToUrl(url: sender.getUrl()!)
  }
}
