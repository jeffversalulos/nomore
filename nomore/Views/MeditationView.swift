import SwiftUI

private enum BreathPhase: String, CaseIterable {
    case inhale
    case hold
    case exhale
    case rest

    var displayName: String {
        switch self {
        case .inhale: return "Inhale"
        case .hold: return "Hold"
        case .exhale: return "Exhale"
        case .rest: return "Rest"
        }
    }

    var instruction: String {
        switch self {
        case .inhale: return "Inhale gently through your nose"
        case .hold: return "Hold your breath softly"
        case .exhale: return "Exhale slowly through your mouth"
        case .rest: return "Rest and prepare for the next breath"
        }
    }
}

private struct SoothingOrb: View {
    let phase: BreathPhase
    let progress: Double // 0...1 within current phase

    private var scale: CGFloat {
        let baseScale: CGFloat = 0.65
        let amplitude: CGFloat = 0.25
        
        switch phase {
        case .inhale:
            return baseScale + amplitude * CGFloat(progress)
        case .hold:
            return baseScale + amplitude
        case .exhale:
            return baseScale + amplitude * CGFloat(1 - progress)
        case .rest:
            return baseScale
        }
    }

    var body: some View {

        ZStack {
            // Soft glowing gradient circles
            Circle()
                .fill(
                    RadialGradient(colors: [Theme.accent.opacity(0.7), .clear], center: .center, startRadius: 20, endRadius: 220)
                )
                .blur(radius: 30)

            Circle()
                .fill(
                    LinearGradient(colors: [Theme.purple.opacity(0.9), Theme.indigo.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(
                    Circle().stroke(Theme.surfaceStroke, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
        }
        .scaleEffect(scale)
        .frame(width: 260, height: 260)
        .animation(.easeInOut(duration: 0.25), value: scale)
        // Removed line progress overlay
        .accessibilityHidden(true)
    }
}

struct MeditationView: View {
    // 4-4-4-4 box breathing (inhale-hold-exhale-rest). You can adjust below if desired.
    private let phaseDurationSeconds: Double = 4

    @State private var isRunning: Bool = false
    @State private var currentPhase: BreathPhase = .inhale
    @State private var phaseElapsedSeconds: Double = 0

    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    private var phaseProgress: Double {
        min(1.0, max(0.0, phaseElapsedSeconds / phaseDurationSeconds))
    }

    private var nextPhase: BreathPhase {
        switch currentPhase {
        case .inhale: return .hold
        case .hold: return .exhale
        case .exhale: return .rest
        case .rest: return .inhale
        }
    }

    var body: some View {
        ZStack {

            VStack(spacing: 28) {
                Spacer(minLength: 24)

                SoothingOrb(phase: currentPhase, progress: phaseProgress)

                VStack(spacing: 6) {
                    Text(currentPhase.displayName)
                        .font(.title.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Text(currentPhase.instruction)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("Next: \(nextPhase.displayName)")
                        .font(.footnote)
                        .foregroundStyle(Theme.textSecondary)
                        .accessibilityLabel("Next: \(nextPhase.displayName)")
                        .accessibilityHint("Upcoming phase")
                }

                HStack(spacing: 12) {
                    Button(action: toggle) {
                        Label(isRunning ? "Pause" : "Start", systemImage: isRunning ? "pause.fill" : "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.surface)
                            .foregroundStyle(Theme.textPrimary)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .accessibilityLabel(isRunning ? "Pause" : "Start")
                    .accessibilityHint("Toggles the meditation guidance")

                    Button(action: reset) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.surface)
                            .foregroundStyle(Theme.textPrimary)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .accessibilityHint("Resets to the beginning of the breathing cycle")
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .appBackground()
        .onReceive(timer) { _ in
            guard isRunning else { return }
            advanceTimer()
        }
        .onChange(of: currentPhase) { _ in
            // Gentle haptic on phase change
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .principal) { Text("Meditate").foregroundStyle(.white) } }
    }

    private func toggle() { isRunning.toggle() }

    private func reset() {
        isRunning = false
        phaseElapsedSeconds = 0
        currentPhase = .inhale
    }

    private func advanceTimer() {
        phaseElapsedSeconds += 0.05
        if phaseElapsedSeconds >= phaseDurationSeconds {
            phaseElapsedSeconds = 0
            moveToNextPhase()
        }
    }

    private func moveToNextPhase() {
        switch currentPhase {
        case .inhale: currentPhase = .hold
        case .hold: currentPhase = .exhale
        case .exhale: currentPhase = .rest
        case .rest: currentPhase = .inhale
        }
    }
}

#Preview {
    MeditationView()
}


