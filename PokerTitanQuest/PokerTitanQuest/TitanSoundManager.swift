//
//  SoundManager.swift
//  PokerTitanQuest
//
//  Created by jin fu on 2024/11/5.
//

import Foundation
import AVFoundation

class TitanSoundManager {
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static var audioPlayer: AVAudioPlayer?
    
    static func playSound(_ effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
            case .flip:
                soundFileName = "flip"
            
            case .shuffle:
                soundFileName = "shuffle"
            
            case .match:
                soundFileName = "match"
            
            case .nomatch:
                soundFileName = "noMatch"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "mp3")
        
        guard bundlePath != nil else {
            
            print("Couldn't find sound file \(soundFileName) in the bundle")
            
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            
        } catch {
            
            print("Couldn't create the audio player object for sound file \(soundFileName)")
        }
        
    }
}
