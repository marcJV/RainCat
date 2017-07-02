//
//  SoundManager.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import AVFoundation
import SpriteKit
import Foundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
  static let sharedInstance = SoundManager()

  var audioPlayer : AVAudioPlayer?
  var trackPosition = 0

  //Music: http://www.bensound.com/royalty-free-music
  static private let tracks = [
    "bensound-clearday",
    "bensound-jazzcomedy",
    "bensound-jazzyfrenchy",
    "bensound-littleidea",
    "jeffmoon-raincat-1" //Except this one, this one is from Mr Moon.
  ]

  static private let extensions = [
    "mp3",
    "mp3",
    "mp3",
    "mp3",
    "wav"
  ]

  private let meowSFX = [
    "cat_meow_1.mp3",
    "cat_meow_2.mp3",
    "cat_meow_3.mp3",
    "cat_meow_4.mp3",
    "cat_meow_5.wav",
    "cat_meow_6.wav",
    "cat_meow_7.mp3"
  ]

  private var soundTempMuted = false

  private let move = "move.wav"
  private let lcdHit = "hit.wav"
  private let lcdPickup = "lcd-pickup.wav"

  private let buttonClick = SKAction.playSoundFileNamed("buttonClick.wav", waitForCompletion: true)

  private override init() {
    //This is private so you can only have one Sound Manager ever.
    trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
  }

  public func startPlaying() {
    if !UserDefaultsManager.sharedInstance.isMuted && (audioPlayer == nil || audioPlayer?.isPlaying == false) {
      let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition],
                                     withExtension: SoundManager.extensions[trackPosition])

      do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        audioPlayer?.delegate = self
      } catch {
        print("audio player failed to load: \(String(describing: soundURL)) \(trackPosition)")

        return
      }

      audioPlayer?.prepareToPlay()

      audioPlayer?.play()

      trackPosition = (trackPosition + 1) % SoundManager.tracks.count
    }
  }

  public func muteMusic() {
    audioPlayer?.setVolume(0, fadeDuration: 0.5)
  }

  public func resumeMusic() {
    audioPlayer?.setVolume(1, fadeDuration: 0.25)

    startPlaying()
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //Just play the next track

    if !soundTempMuted {
      startPlaying()
    }
  }

  func toggleMute() -> Bool {
    let isMuted = UserDefaultsManager.sharedInstance.toggleMute()
    if isMuted {
      muteMusic()
    } else if (audioPlayer == nil || audioPlayer?.isPlaying == false) {
      startPlaying()
    } else {
      resumeMusic()
    }

    return isMuted
  }

  public func meow(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted && node.action(forKey: "action_sound_effect") == nil {

      let selectedSFX = Int(arc4random_uniform(UInt32(meowSFX.count)))

      node.run(SKAction.playSoundFileNamed(meowSFX[selectedSFX], waitForCompletion: true),
          withKey: "action_sound_effect")
    }
  }

  public static func playLCDPickup(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SKAction.playSoundFileNamed(SoundManager.sharedInstance.lcdPickup, waitForCompletion: true),
               withKey: "lcd-pickup")
    }
  }

  public static func playLCDMove(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SKAction.playSoundFileNamed(SoundManager.sharedInstance.move, waitForCompletion: true),
               withKey: "lcd-move")
    }
  }

  public static func playLCDHit(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SKAction.playSoundFileNamed(SoundManager.sharedInstance.lcdHit, waitForCompletion: true),
               withKey: "lcd-hit")
    }
  }

  public static func playButtonClick(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SoundManager.sharedInstance.buttonClick, withKey: "buttonClick")
    }
  }

  public static func playUmbrellaHit(node : SKNode) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SoundManager.sharedInstance.buttonClick, withKey: "umbrellaHit")
    }
  }
}




