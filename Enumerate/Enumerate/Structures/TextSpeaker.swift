import Foundation
import AVFoundation

struct TextSpeaker {
    let speechSynth = AVSpeechSynthesizer()
    let voice: AVSpeechSynthesisVoice?
    
    init(voice: String) {
        self.voice = AVSpeechSynthesisVoice(identifier: voice) ?? nil
        
        print("Making Speaker with voice", voice)
    }
    
    func textSpeak( string: String ) {
        let utterance = AVSpeechUtterance(string: string)
        if let isVoice = voice {
            utterance.voice = isVoice
            utterance.rate = 0.4
        }
        speechSynth.speak(utterance)
    }
    
    static func getVoiceCodes() -> [VoiceIdentifier] {
        // Make these usnique
        let list = AVSpeechSynthesisVoice.speechVoices()
        var out: [VoiceIdentifier] = []
        
        for item in list {
            if item.identifier.contains("com.apple.voice.compact") {
                out.append( VoiceIdentifier(id: item.identifier, item: item))
            }
        }
        return out
    }
}
