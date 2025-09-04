import SwiftUI



struct MeditationView: View {
    @EnvironmentObject var journalStore: JournalStore
    
    // 4-4-4-4 box breathing (inhale-hold-exhale-rest). You can adjust below if desired.
    private let phaseDurationSeconds: Double = 4

    @State private var isRunning: Bool = false
    @State private var currentPhase: BreathPhase = .inhale
    @State private var phaseElapsedSeconds: Double = 0
    @State private var sessionStartTime: Date?
    @State private var showingCompletion: Bool = false
    @State private var showingJournalView: Bool = false

    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    private var sessionDuration: TimeInterval {
        guard let startTime = sessionStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }

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

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button(action: toggle) {
                            Label(isRunning ? "Pause" : "Start", systemImage: isRunning ? "pause.fill" : "play.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Theme.surface)
                                .foregroundStyle(Theme.textPrimary)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness))
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
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .accessibilityHint("Resets to the beginning of the breathing cycle")
                    }
                    
                    if isRunning {
                        Button(action: finishSession) {
                            Label("Finish Session", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Theme.mint)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .accessibilityHint("Complete the meditation session")
                    }
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
        .fullScreenCover(isPresented: $showingCompletion) {
            SessionCompletionSheet(
                sessionDuration: sessionDuration,
                onJournalTap: {
                    showingCompletion = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showingJournalView = true
                    }
                },
                onDismiss: {
                    showingCompletion = false
                }
            )
        }
        .sheet(isPresented: $showingJournalView) {
            JournalView()
                .environmentObject(journalStore)
        }
    }

    private func toggle() { 
        if !isRunning {
            // Starting a new session
            sessionStartTime = Date()
        }
        isRunning.toggle() 
    }

    private func reset() {
        isRunning = false
        phaseElapsedSeconds = 0
        currentPhase = .inhale
        sessionStartTime = nil
    }
    
    private func finishSession() {
        isRunning = false
        showingCompletion = true
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
        .environmentObject(JournalStore())
}


