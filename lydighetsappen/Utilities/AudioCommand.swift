//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import AVFoundation

@MainActor
@Observable
final class AudioCommand: NSObject, AVSpeechSynthesizerDelegate {
    @ObservationIgnored private let synth = AVSpeechSynthesizer()
    /// Utterances som noen venter på at skal bli ferdig.
    @ObservationIgnored private var continuations: [ObjectIdentifier: CheckedContinuation<Void, Never>] = [:]
    
    /// Den best tilgjengelige norske stemmen på enheten.
    let voice: AVSpeechSynthesisVoice?
    
    /// Sant hvis enheten har en forbedret eller premium norsk stemme installert.
    /// Standardstemmen låter mest robotaktig, så brukeren kan oppfordres til å laste ned en bedre.
    var hasEnhancedVoice: Bool {
        guard let voice else { return false }
        return voice.quality != .default
    }
    
    override init() {
        voice = Self.bestNorwegianVoice()
        super.init()
        synth.delegate = self
        
        Task.detached(priority: .userInitiated) {
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, options: [.duckOthers])
            try? session.setActive(true)
        }
    }
    
    /// Velger norsk stemme med høyest kvalitet (premium > enhanced > default).
    private static func bestNorwegianVoice() -> AVSpeechSynthesisVoice? {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language == "nb-NO" }
            .max { $0.quality.rawValue < $1.quality.rawValue }
            ?? AVSpeechSynthesisVoice(language: "nb-NO")
    }
    
    private func makeUtterance(_ text: String) -> AVSpeechUtterance {
        let u = AVSpeechUtterance(string: text)
        u.voice = voice
        u.rate = AVSpeechUtteranceDefaultSpeechRate
        u.volume = 1.0
        return u
    }
    
    func say(_ text: String) {
        synth.speak(makeUtterance(text))
    }
    
    /// Leser opp teksten og returnerer når opplesingen er ferdig (eller avbrutt).
    func speak(_ text: String) async {
        let utterance = makeUtterance(text)
        await withCheckedContinuation { continuation in
            continuations[ObjectIdentifier(utterance)] = continuation
            synth.speak(utterance)
        }
    }
    
    /// Stopper opplesingen umiddelbart.
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    
    private func finish(_ id: ObjectIdentifier) {
        continuations.removeValue(forKey: id)?.resume()
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let id = ObjectIdentifier(utterance)
        Task { @MainActor in finish(id) }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let id = ObjectIdentifier(utterance)
        Task { @MainActor in finish(id) }
    }
}
