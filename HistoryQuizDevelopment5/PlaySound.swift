//
//  PlaySound.swift
//  HistoryQuizDevelopement2
//
//  Created by Normand Martin on 2020-02-13.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
import AVFoundation

// Audio - player

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find and play the sound file")
        }
    }
}
