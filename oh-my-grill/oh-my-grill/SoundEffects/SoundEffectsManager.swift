//
//  SoundEffectsManager.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 11/12/25.
//

import Foundation
import AVFoundation

class SoundEffectsManager {
    static let instance = SoundEffectsManager()

    private var player: AVAudioPlayer?

    func playClick() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "wav") else {
            print("Sound file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("error playing sound: \(error)")
        }
    }
    
    func playMiniGame() {
        guard let url = Bundle.main.url(forResource: "minigame", withExtension: "wav") else {
            print("Sound file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("error playing sound: \(error)")
        }
    }
    
    func playSuccess() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "wav") else {
            print("Sound file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("error playing sound: \(error)")
        }
    }
    
    func playFail() {
        guard let url = Bundle.main.url(forResource: "fail", withExtension: "wav") else {
            print("Sound file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("error playing sound: \(error)")
        }
    }
}
