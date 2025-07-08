import SwiftUI
import AVFoundation
import AudioToolbox

class TimerViewModel: ObservableObject {
    @Published var focusMinutes: Double = 25 {
        didSet { if !isRunning { timeRemaining = focusMinutes * 60 } }
    }
    @Published var relaxMinutes: Double = 5
    @Published private(set) var isFocusPhase: Bool = true
    @Published private(set) var timeRemaining: TimeInterval = 25 * 60
    @Published private(set) var isRunning: Bool = false
    @Published var selectedSound: TimerSound = .gentleChime
    @Published var vibrationEnabled: Bool = false

    private var timer: Timer?

    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var currentPhaseTitle: String {
        isFocusPhase ? "Focus" : "Relax"
    }

    func toggleRunning() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func start() {
        if timeRemaining <= 0 {
            resetTime()
        }
        isRunning = true
        scheduleTimer()
    }

    func pause() {
        timer?.invalidate()
        isRunning = false
    }

    func reset() {
        timer?.invalidate()
        isRunning = false
        isFocusPhase = true
        timeRemaining = focusMinutes * 60
    }

    private func scheduleTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        guard timeRemaining > 0 else {
            notifyEndOfInterval()
            isFocusPhase.toggle()
            resetTime()
            return
        }
        timeRemaining -= 1
    }

    private func resetTime() {
        timeRemaining = (isFocusPhase ? focusMinutes : relaxMinutes) * 60
    }

    private func notifyEndOfInterval() {
        playSound()
        if vibrationEnabled {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    private func playSound() {
        guard let url = selectedSound.url else { return }
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
}

enum TimerSound: String, CaseIterable, Identifiable {
    case gentleChime = "Gentle Chime"
    case softBell = "Soft Bell"
    case mellowBeat = "Mellow Beat"

    var id: String { rawValue }

    var fileName: String {
        switch self {
        case .gentleChime: return "chime"
        case .softBell: return "bell"
        case .mellowBeat: return "beat"
        }
    }

    var url: URL? {
        Bundle.main.url(forResource: fileName, withExtension: "mp3")
    }
}
