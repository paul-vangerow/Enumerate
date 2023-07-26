import Foundation
import AVFoundation

struct VoiceIdentifier: Identifiable, Equatable {
    let id: String
    let item: AVSpeechSynthesisVoice
}
