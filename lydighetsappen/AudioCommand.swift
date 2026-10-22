//
//  AudioCommand.swift
//  lydighetsappen
//
//  Created by Tri Nguyen on 22/10/2026.
//

import Foundation
import AVFoundation

@Observable
final class AudioCommand {
    private let synth = AVSpeechSynthesizer()
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func say(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "nb-NO")
        u.rate = 0.5
        u.volume = 1.0
        synth.speak(u)
    }
}
