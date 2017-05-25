//
//  SoundManager.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import AVFoundation
import SpriteKit
import AudioKit
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
    "bensound-littleidea"
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

  private let tickSFX = "blip_0012.wav"
  private let chipSFX = "Chip_Hat_10.wav"
  private let kick1 = "kick_003.wav"
  private let kick2 = "kick_004.wav"
  private var kick = true

  private override init() {
    //This is private so you can only have one Sound Manager ever.
    trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
  }

  public func startPlaying() {
    if !UserDefaultsManager.sharedInstance.isMuted && (audioPlayer == nil || audioPlayer?.isPlaying == false) {
      let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition], withExtension: "mp3")

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

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //Just play the next track
    startPlaying()
  }

  func toggleMute() -> Bool {
    let isMuted = UserDefaultsManager.sharedInstance.toggleMute()
    if isMuted {
      audioPlayer?.stop()
    } else {
      startPlaying()
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

  public static func playTick(node :SKNode) {

    var sfx : String

    if SoundManager.sharedInstance.kick {
      sfx = SoundManager.sharedInstance.kick1
    } else {
      sfx = SoundManager.sharedInstance.kick2
    }

    SoundManager.sharedInstance.kick = !SoundManager.sharedInstance.kick

//    SoundManager.sharedInstance.tickSFX

    if !UserDefaultsManager.sharedInstance.isMuted {
      node.run(SKAction.playSoundFileNamed(SoundManager.sharedInstance.chipSFX, waitForCompletion: true),
               withKey: "tick")
    }
  }

  var oscillator : AKOscillator!
  var reverb : AKReverb!
  var generator : AKOperationGenerator!

  public func testTick() {
    //This is the most annoying thing ever.

//    do {
//    let pulse = 0.23 // seconds
//
//    let sampler = AKSampler()
//    try sampler.loadWav("cat_meow_6")
//
//    var delay = AKDelay(sampler)
//    delay.time = pulse * 1.5
//    delay.dryWetMix = 0.3
//    delay.feedback = 0.2
//
//    let reverb = AKReverb(delay)
//    reverb.loadFactoryPreset(.largeRoom)
//
//    var mixer = AKMixer(reverb)
//    mixer.volume = 5.0
//    
//    AudioKit.output = mixer
//    AudioKit.start()
//
//
//      AKPlaygroundLoop(every: 1) { _ in
//        let scale = [0, 2, 4, 5, 7, 9, 11, 12]
//        var note = scale.randomElement()
//        let octave = [3, 4, 5, 6, 7].randomElement() * 12
//        if random(0, 10) < 1.0 { note += 1 }
//        if !scale.contains(note % 12) { print("ACCIDENT!") }
//        if random(0, 6) > 1.0 { sampler.play(noteNumber: MIDINoteNumber(note + octave)) }
//      }
//    } catch {
//    }
  }
}
