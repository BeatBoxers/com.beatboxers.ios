//
//  Player.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 30/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation
import AVFoundation

private let AudioPlayerSingletonInstance = AudioPlayer()

class AudioPlayer {
	private let LOG_TAG = "Player"
	
	class var sharedInstance: AudioPlayer {
		return AudioPlayerSingletonInstance
	}
	
	static let HARD_FORCE_THRESHOLD = 500
	
	private let maxSoundIndex = 10//this may be a bit extreme...
	
	static let UNKNOWN = "unknown"
	
	static let BASS = "bass"
	private var bassHard = [AVAudioPlayer]()
	private var bassHardIndex: Int = 0
	private var bassSoft = [AVAudioPlayer]()
	private var bassSoftIndex: Int = 0
	
	static let CRASH = "crash"
	private var crashHard = [AVAudioPlayer]()
	private var crashHardIndex: Int = 0
	private var crashSoft = [AVAudioPlayer]()
	private var crashSoftIndex: Int = 0
	
	static let FLOOR_TOM = "floorTom"
	private var floorTomHard = [AVAudioPlayer]()
	private var floorTomHardIndex: Int = 0
	private var floorTomSoft = [AVAudioPlayer]()
	private var floorTomSoftIndex: Int = 0
	
	static let HIGH_HAT = "highHat"
	private var highHatHard = [AVAudioPlayer]()
	private var highHatHardIndex: Int = 0
	private var highHatSoft = [AVAudioPlayer]()
	private var highHatSoftIndex: Int = 0
	
	static let RIDE = "ride"
	private var rideHard = [AVAudioPlayer]()
	private var rideHardIndex: Int = 0
	private var rideSoft = [AVAudioPlayer]()
	private var rideSoftIndex: Int = 0
	
	static let SNARE = "snare"
	private var snareHard = [AVAudioPlayer]()
	private var snareHardIndex: Int = 0
	private var snareSoft = [AVAudioPlayer]()
	private var snareSoftIndex: Int = 0
	
	static let TOM_1 = "tom1"
	private var tom1Hard = [AVAudioPlayer]()
	private var tom1HardIndex: Int = 0
	private var tom1Soft = [AVAudioPlayer]()
	private var tom1SoftIndex: Int = 0
	
	static let TOM_2 = "tom2"
	private var tom2Hard = [AVAudioPlayer]()
	private var tom2HardIndex: Int = 0
	private var tom2Soft = [AVAudioPlayer]()
	private var tom2SoftIndex: Int = 0
	
	func setup() {
		AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
		AVAudioSession.sharedInstance().setActive(true, error: nil)
		
		setupAudio("Audio/Drum/bass_hard", audioArray: &bassHard)
		setupAudio("Audio/Drum/bass_soft", audioArray: &bassSoft)
		
		setupAudio("Audio/Drum/crash_hard", audioArray: &crashHard)
		setupAudio("Audio/Drum/crash_soft", audioArray: &crashSoft)
		
		setupAudio("Audio/Drum/floor_tom_hard", audioArray: &floorTomHard)
		setupAudio("Audio/Drum/floor_tom_soft", audioArray: &floorTomSoft)
		
		setupAudio("Audio/Drum/high_hat_hard", audioArray: &highHatHard)
		setupAudio("Audio/Drum/high_hat_soft", audioArray: &highHatSoft)
		
		setupAudio("Audio/Drum/ride_hard", audioArray: &rideHard)
		setupAudio("Audio/Drum/ride_soft", audioArray: &rideSoft)
		
		setupAudio("Audio/Drum/snare_hard", audioArray: &snareHard)
		setupAudio("Audio/Drum/snare_soft", audioArray: &snareSoft)
		
		setupAudio("Audio/Drum/tom_1_hard", audioArray: &tom1Hard)
		setupAudio("Audio/Drum/tom_1_soft", audioArray: &tom1Soft)
		
		setupAudio("Audio/Drum/tom_2_hard", audioArray: &tom2Hard)
		setupAudio("Audio/Drum/tom_2_soft", audioArray: &tom2Soft)
	}
	
	private func setupAudio(path: String, inout audioArray: [AVAudioPlayer]) {
		let url = NSBundle.mainBundle().pathForResource(path, ofType: "mp3")!
		
		for i in 0...maxSoundIndex {
			audioArray.append(AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: url), error: nil))
			audioArray[i].prepareToPlay()
		}
	}
	
	func play(instrument: String, strength: Int = AudioPlayer.HARD_FORCE_THRESHOLD) {
		let isHard = (strength >= AudioPlayer.HARD_FORCE_THRESHOLD)
		
		switch instrument {
			case AudioPlayer.BASS:
				isHard ? bassHard[bassHardIndex].play() : bassSoft[bassSoftIndex].play()
				isHard ? incrementIndex(&bassHardIndex) : incrementIndex(&bassSoftIndex)
			case AudioPlayer.CRASH:
				isHard ? crashHard[crashHardIndex].play() : crashSoft[crashSoftIndex].play()
				isHard ? incrementIndex(&crashHardIndex) : incrementIndex(&crashSoftIndex)
			case AudioPlayer.FLOOR_TOM:
				isHard ? floorTomHard[floorTomHardIndex].play() : floorTomSoft[floorTomSoftIndex].play()
				isHard ? incrementIndex(&floorTomHardIndex) : incrementIndex(&floorTomSoftIndex)
			case AudioPlayer.HIGH_HAT:
				isHard ? highHatHard[highHatHardIndex].play() : highHatSoft[highHatSoftIndex].play()
				isHard ? incrementIndex(&highHatHardIndex) : incrementIndex(&highHatSoftIndex)
			case AudioPlayer.RIDE:
				isHard ? rideHard[rideHardIndex].play() : rideSoft[rideSoftIndex].play()
				isHard ? incrementIndex(&rideHardIndex) : incrementIndex(&rideSoftIndex)
			case AudioPlayer.SNARE:
				isHard ? snareHard[snareHardIndex].play() : snareSoft[snareSoftIndex].play()
				isHard ? incrementIndex(&snareHardIndex) : incrementIndex(&snareSoftIndex)
			case AudioPlayer.TOM_1:
				isHard ? tom1Hard[tom1HardIndex].play() : tom1Soft[tom1SoftIndex].play()
				isHard ? incrementIndex(&tom1HardIndex) : incrementIndex(&tom1SoftIndex)
			case AudioPlayer.TOM_2:
				isHard ? tom2Hard[tom2HardIndex].play() : bassSoft[tom2SoftIndex].play()
				isHard ? incrementIndex(&tom2HardIndex) : incrementIndex(&tom2SoftIndex)
			default:
				Log.e(LOG_TAG, "Invalid instrument passed to play()")
		}
	}
	
	private func incrementIndex(inout index: Int) {
		index = (index == maxSoundIndex ? 0 : index + 1)
	}
}