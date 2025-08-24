import SwiftUI



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


