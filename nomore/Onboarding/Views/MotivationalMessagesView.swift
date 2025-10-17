//
//  MotivationalMessagesView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct MotivationalMessagesView: View {
    let onContinue: () -> Void
    
    @State private var currentMessageIndex = 0
    @State private var showContent = false
    
    private let messages = [
        MotivationalMessage(
            emoji: "💪",
            text: "You've taken the first step towards freedom",
            showTapToContinue: true
        ),
        MotivationalMessage(
            emoji: "🌟",
            text: "Every moment of resistance builds your strength",
            showTapToContinue: true
        ),
        MotivationalMessage(
            emoji: "🔥",
            text: "You are stronger than your urges",
            showTapToContinue: true
        ),
        MotivationalMessage(
            emoji: "🎯",
            text: "Your future self is counting on you",
            showTapToContinue: true
        ),
        MotivationalMessage(
            emoji: "✨",
            text: "This is your moment to reclaim control",
            showTapToContinue: false
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                // Main content area with fixed frame to prevent layout shifts
                VStack(spacing: 40) {
                    // Message text
                    Text(messages[currentMessageIndex].text)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 40)
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.65), value: showContent)
                    
                    // Emoji
                    Text(messages[currentMessageIndex].emoji)
                        .font(.system(size: 120))
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.65), value: showContent)
                }
                .frame(height: 300) // Fixed height to prevent layout shifts
                
                Spacer()
                
                // Bottom section
                VStack(spacing: 20) {
                    if messages[currentMessageIndex].showTapToContinue {
                        // Tap to continue text
                        Text("tap to continue")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .opacity(showContent ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.65), value: showContent)
                    } else {
                        // I'm ready button
                        Button(action: onContinue) {
                            Text("I'm ready")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(Color.white)
                                )
                        }
                        .padding(.horizontal, 40)
                        .opacity(showContent ? 1.0 : 0.0)
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .animation(.easeOut(duration: 0.65), value: showContent)
                    }
                }
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onTapGesture {
            if messages[currentMessageIndex].showTapToContinue {
                nextMessage()
            }
        }
        .onAppear {
            showContent = true
        }
    }
    
    private func nextMessage() {
        guard currentMessageIndex < messages.count - 1 else { return }
        
        // Fade out current content
        withAnimation(.easeOut(duration: 0.65)) {
            showContent = false
        }
        
        // Wait for fade out plus additional pause, then change message and fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
            currentMessageIndex += 1
            
            withAnimation(.easeOut(duration: 0.65)) {
                showContent = true
            }
        }
    }
}

struct MotivationalMessage {
    let emoji: String
    let text: String
    let showTapToContinue: Bool
}

#Preview {
    MotivationalMessagesView {
        print("Continue tapped")
    }
    .appBackground()
}
