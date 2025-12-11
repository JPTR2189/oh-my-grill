//
//  SoundEffectsManager.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 11/12/25.
//

import Foundation
import AVFoundation
import SwiftUI

class SoundEffectsManager {
    static let instance = SoundEffectsManager()

    @AppStorage("isSoundOn") private var isSoundOn: Bool = true

    private var player: AVAudioPlayer?

    private func playSound(named name: String, ext: String = "wav") {
        guard isSoundOn else { return }

        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
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

    func playClick() { playSound(named: "click") }
    func playSuccess() { playSound(named: "success") }
    func playFail() { playSound(named: "fail") }
}
