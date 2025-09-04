//
//  SessionCompletionSheet.swift
//  nomore
//
//  Created by Aa on 2025-01-26.
//

import SwiftUI

struct SessionCompletionSheet: View {
    let sessionDuration: TimeInterval
    let onJournalTap: () -> Void
    let onDismiss: () -> Void
    
    private var durationText: String {
        let minutes = Int(sessionDuration / 60)
        let seconds = Int(sessionDuration.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") and \(seconds) second\(seconds == 1 ? "" : "s")"
        } else {
            return "\(seconds) second\(seconds == 1 ? "" : "s")"
        }
    }
    
    private var shortDurationText: String {
        let minutes = Int(sessionDuration / 60)
        let seconds = Int(sessionDuration.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Celebration
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.mint)
                        .scaleEffect(1.0)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                                // Animation handled by onAppear
                            }
                        }
                    
                    Text("Session Complete!")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("You meditated for \(durationText)")
                        .font(.title3)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Session summary card
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundStyle(Theme.accent)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Duration")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            Text(shortDurationText)
                                .font(.title2.bold())
                                .foregroundStyle(Theme.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Pattern")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            Text("Box Breathing")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.textPrimary)
                        }
                    }
                }
                .padding(24)
                .background(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .softShadow()
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 16) {
                    Button(action: onJournalTap) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.headline)
                            Text("Reflect in Journal")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .accessibilityHint("Open journal to reflect on your meditation")
                    
                    Button(action: onDismiss) {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.surface)
                            .foregroundStyle(Theme.textPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .accessibilityHint("Close session completion")
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .appBackground()
        .onAppear {
            // Celebration haptic
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

#Preview {
    SessionCompletionSheet(
        sessionDuration: 185, // 3 minutes 5 seconds
        onJournalTap: {},
        onDismiss: {}
    )
}
