//
//  SwiftUIView.swift
//  oh-my-grill
//
//  Created by Vítor Martins Da Silva on 05/12/25.
//

import SwiftUI
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    var currentMusic: MusicType?
    
    enum MusicType: String {
        case menu = "Musica out game"
        case game = "Musica in game"
    }
    
    func playMusic(type: MusicType) {
        if currentMusic == type && player?.isPlaying == true {
            return
        }
        
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else {
            print("Arquivo de música não encontrado: \(type.rawValue)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.numberOfLoops = -1
            player?.play()
            
            currentMusic = type
            
        } catch {
            print("Erro ao tocar música: \(error.localizedDescription)")
        }
    }    
    func stopMusic() {
        player?.stop()
        currentMusic = nil
    }
}
