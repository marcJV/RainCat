//
//  SKAction.swift
//  RainCat
//
//  http://stackoverflow.com/a/27952397
//

import SpriteKit

public class ColorAction {
  // In the class that calls colorTransitionAction
  // Include these variables
  // In my code its the class that aggregates the sprite
  var fr : CGFloat = 0.0
  var fg : CGFloat = 0.0
  var fb : CGFloat = 0.0
  var fa : CGFloat = 0.0
  var tr : CGFloat = 0.0
  var tg : CGFloat = 0.0
  var tb : CGFloat = 0.0
  var ta : CGFloat = 0.0

  func lerp(_ a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat {
    return (b - a) * fraction + a
  }

  func colorTransitionAction(fromColor : UIColor, toColor : UIColor, duration : Double = 1.0) -> SKAction {
    fromColor.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
    toColor.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)

    return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
      let fraction = CGFloat(elapsedTime / CGFloat(duration))
      let transColor = UIColor(red: self.lerp(self.fr, b: self.tr, fraction: fraction),
                               green: self.lerp(self.fg, b: self.tg, fraction: fraction),
                               blue: self.lerp(self.fb, b: self.tb, fraction: fraction),
                               alpha: self.lerp(self.fa, b: self.ta, fraction: fraction))

      if let node = node as? SKShapeNode {
        node.fillColor = transColor
      } else if let node = node as? SKSpriteNode {
        node.color = transColor
      } else if let node = node as? SKLabelNode {
        node.fontColor = transColor
      }
      }
    )
  }
}
