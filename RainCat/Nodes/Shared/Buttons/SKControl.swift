//
//  SKAControl.swift
//  SKAButton
//
//  Created by Marc Vandehey on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//
import Foundation
import SpriteKit

/**
 SKAControlEvent Mimics the usefulness of UIControl class
 - Note: None - Used internally only

 TouchDown - User Touches Down on the button

 TouchUpInside - User releases Touch inside the bounds of the button

 TouchUpOutside - User releases Touch outside the bounds of the button

 DragOutside - User Drags touch from outside the bounds of the button and stays outside

 DragInside - User Drags touch from inside the bounds of the button and stays inside

 DragEnter - User Drags touch from outside the bounds of the button to inside the bounds of the button

 DragExit - User Drags touch from inside the bounds of the button to outside the bounds of the button
 */
struct SKAControlEvent: OptionSet, Hashable {
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }

  static var None:           SKAControlEvent   { return SKAControlEvent(rawValue: 0) }
  static var TouchDown:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 0) }
  static var TouchUpInside:  SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 1) }
  static var TouchUpOutside: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 2) }
  static var DragOutside:    SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 3) }
  static var DragInside:     SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 4) }
  static var DragEnter:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 5) }
  static var DragExit:       SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 6) }
  static var TouchCancelled: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 7) }
  static var ValueChanged:   SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 8) }
  static var AllOptions:     [SKAControlEvent] {
    return [.TouchDown, .TouchUpInside, .TouchUpOutside, .DragOutside, .DragInside, .DragEnter, .DragExit, .TouchCancelled, .ValueChanged]
  }

  var hashValue: Int {
    return rawValue.hashValue
  }
}

/**
 Container for SKAControl Selectors
 - Parameter target: target Object to call the selector on
 - Parameter selector: Selector to call
 */
struct SKASelector {
  unowned let target: AnyObject
  let selector: Selector
}

/// SKSpriteNode set up to mimic the utility of UIControl
class SKAControlSprite : SKSpriteNode {
  fileprivate var selectors = [SKAControlEvent: [SKASelector]]()

  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)

    isUserInteractionEnabled = true
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    isUserInteractionEnabled = true
  }

  /**
   Current State of the button
   - Note: ReadOnly
   */
  private(set) var controlState:SKAControlState = .Normal {
    didSet {
      if oldValue.rawValue != controlState.rawValue {
        updateControl()
      }
    }
  }

  /**
   Sets the button to the selected state
   - Note: If an SKAction is taking place, the selected state may not show properly
   */
  var selected:Bool {
    get {
      return controlState.contains(.Selected)
    }
    set(newValue) {
      if newValue {
        controlState.insert(.Selected)
      } else {
        controlState.subtract(.Selected)
      }

      performSelectorsForEvent(.ValueChanged)
    }
  }

  var value:CGFloat = 0 {
    didSet {
      performSelectorsForEvent(.ValueChanged)
    }
  }

  /**
   Sets the button to the enabled/disabled state. In a disabled state, the button will not trigger selectors
   - Note: If an SKAction is taking place, the disabled state may not show properly
   */
  var enabled:Bool {
    get {
      return !controlState.contains(.Disabled)
    }
    set(newValue) {
      if newValue {
        controlState.subtract(.Disabled)
      } else {
        controlState.insert(.Disabled)
      }
    }
  }

  // MARK: - Selector Events

  /**
   Add target for a SKAControlEvent. You may call this multiple times and you can specify multiple targets for any event.
   - Parameter target: Object the selecter will be called on
   - Parameter selector: The chosen selector for the event that is a member of the target
   - Parameter events: SKAControlEvents that you want to register the selector to
   - Returns: void
   */
  func addTarget(_ target: AnyObject, selector: Selector, forControlEvents events: SKAControlEvent) {
    isUserInteractionEnabled = true

    let buttonSelector = SKASelector(target: target, selector: selector)

    addButtonSelector(buttonSelector, forControlEvents: events)
  }

  /**
   Add Selector(s) to our dictionary of actions based on the SKAControlEvent
   - Parameter buttonSelector: Internal struct containing the selector and the target
   - Parameter events: SKAControl event(s) associated to the selector
   - Returns: void
   */
  fileprivate func addButtonSelector(_ buttonSelector: SKASelector, forControlEvents events: SKAControlEvent) {
    for option in SKAControlEvent.AllOptions where events.contains(option) {
      if var buttonSelectors = selectors[option] {
        buttonSelectors.append(buttonSelector)
        selectors[option] = buttonSelectors
      } else {
        selectors[option] = [buttonSelector]
      }
    }
  }

  /**
   Checks if there are any listed selectors for the control event, and performs them
   - Parameter event: Single control event
   - Returns: void
   */
  fileprivate func performSelectorsForEvent(_ event:SKAControlEvent) {
    guard let selectors = selectors[event] else { return }
    performSelectors(selectors)
  }

  /*
   Loops through the selected actions and performs the selectors associated to them
   - Parameter buttonSelectors: buttonSelectors Array of button selectors to perform
   - Returns: void
   */
  fileprivate func performSelectors(_ buttonSelectors: [SKASelector]) {
    for selector in buttonSelectors {
      let _ = selector.target.perform(selector.selector, with: self);
    }
  }

  /**
   Update the control based on the state.
   - Note: Override this in children
   - Returns: void
   */
  func updateControl() {
    //Override this in children
  }

  /// Save a touch to help determine if the touch just entered or exited the node
  fileprivate var lastEvent:SKAControlEvent = .None
  private(set) var currentTouch : UITouch?

  // MARK: - Touch Methods

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !enabled { return }

    for touch in touches {
      if beginTracking(touch, with: event) {
        lastEvent = .TouchDown

        performSelectorsForEvent(.TouchDown)
        controlState.insert(.Highlighted)
        controlState.subtract(.Normal)
      }
    }

    super.touchesBegan(touches, with:event)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if continueTracking(touch, with: event), let parent = parent, enabled {
        let currentLocation = (touch.location(in: parent))

        if lastEvent == .DragInside && !contains(currentLocation) {
          ///Touch Moved Outside Node
          controlState.subtract(.Highlighted)
          performSelectorsForEvent(.DragExit)
          lastEvent = .DragExit
        } else if lastEvent == .DragOutside && contains(currentLocation) {
          ///Touched Moved Inside Node
          controlState.insert(.Highlighted)
          performSelectorsForEvent(.DragEnter)
          lastEvent = .DragEnter
        } else if !contains(currentLocation) {
          /// Touch stayed Outside Node
          performSelectorsForEvent(.DragOutside)
          lastEvent = .DragOutside
        } else if contains(currentLocation) {
          ///Touch Stayed Inside Node
          performSelectorsForEvent(.DragInside)
          lastEvent = .DragInside
        }
      }
    }

    super.touchesMoved(touches, with: event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    lastEvent = .None
    for touch in touches {
      if endTracking(touch, with: event), let parent = parent, enabled {

        if contains(touch.location(in: parent)) {
          performSelectorsForEvent(.TouchUpInside)
        } else {
          performSelectorsForEvent(.TouchUpOutside)
        }

        controlState.subtract(.Highlighted)
        controlState.insert(.Normal)
      }
    }

    super.touchesEnded(touches, with: event)
  }


  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    lastEvent = .None

    for touch in touches {
      if cancelTracking(touch, with: event) {
        performSelectorsForEvent( .TouchCancelled)
        controlState.subtract(.Highlighted)
        controlState.insert(.Normal)
      }
    }

    super.touchesCancelled(touches, with: event)
  }

  func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    if currentTouch == nil {
      currentTouch = touch
      return true
    }

    return false
  }

  func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    return currentTouch == touch
  }

  func endTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    if currentTouch == touch {
      currentTouch = nil
      return true
    }

    return false
  }

  func cancelTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    if currentTouch == touch {
      currentTouch = nil
      return true
    }

    return false
  }


  /**
   SKAControlState Possible states for the SKAButton
   - Note: Normal - No States are active on the button

   Highlighted - Button is being touched

   Selected - Button in selected state

   Disabled - Button in disabled state, will ignore SKAControlEvents
   */
  struct SKAControlState: OptionSet, Hashable {
    let rawValue: Int
    let key: String
    init(rawValue: Int) {
      self.rawValue = rawValue
      self.key = "\(rawValue)"
    }

    static var Normal:       SKAControlState { return SKAControlState(rawValue: 0 << 0) }
    static var Highlighted:  SKAControlState { return SKAControlState(rawValue: 1 << 0) }
    static var Selected:     SKAControlState { return SKAControlState(rawValue: 1 << 1) }
    static var Disabled:     SKAControlState { return SKAControlState(rawValue: 1 << 2) }
    static var AllOptions: [SKAControlState] {
      return [.Normal, .Highlighted, .Selected, .Disabled]
    }
    var hashValue: Int {
      return rawValue.hashValue
    }
  }
}
