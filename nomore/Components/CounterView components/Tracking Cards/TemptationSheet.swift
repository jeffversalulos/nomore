import SwiftUI

struct TemptationSheet: View {
    @Binding var isPresented: Bool
    @Binding var isTempted: Bool
    @Binding var selectedMoodEmoji: String
    @State private var tempIsTempted: Bool = false
    
    // Use computed property directly instead of separate state
    private var selectedMood: MoodEmoji {
        get {
            MoodEmoji.allCases.first { $0.rawValue == selectedMoodEmoji } ?? .happy
        }
        nonmutating set {
            selectedMoodEmoji = newValue.rawValue
        }
    }
    
    // Mood options matching your sketch
    enum MoodEmoji: String, CaseIterable, Hashable {
        case happy = "😄"
        case sleepy = "😴" 
        case neutral = "😐"
        case sad = "😟"
        case crying = "😢"
        
        var description: String {
            switch self {
            case .happy: return "Happy"
            case .sleepy: return "Sleepy"
            case .neutral: return "Neutral"
            case .sad: return "Sad"
            case .crying: return "Crying"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient matching your sketch
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with close button
                    HStack {
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(.black.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Main content
                    VStack(spacing: 40) {
                        // Question text
                        Text("How do you feel right now?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        // Mood emoji selection
                        HStack(spacing: 12) {
                            ForEach(MoodEmoji.allCases, id: \.self) { mood in
                                VStack {
                                    Text(mood.rawValue)
                                        .font(.system(size: 40))
                                        .frame(width: 56, height: 56)
                                        .background(
                                            selectedMood == mood ? 
                                            Color.white.opacity(0.2) : 
                                            Color.clear
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(
                                                    selectedMood == mood ? 
                                                    Color.white.opacity(0.5) : 
                                                    Color.clear, 
                                                    lineWidth: 2
                                                )
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                        .scaleEffect(selectedMood == mood ? 1.1 : 1.0)
                                        .onTapGesture {
                                            selectedMood = mood
                                        }
                                }
                            }
                        }
                        
                        // Temptation toggle section
                        VStack(spacing: 20) {
                            HStack {
                                Text("Are you tempted to relapse right now?")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer()
                                
                                // Custom toggle
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        tempIsTempted.toggle()
                                    }
                                } label: {
                                    ZStack {
                                        // Background track
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(tempIsTempted ? .blue.opacity(0.3) : .blue.opacity(0.3))
                                            .frame(width: 60, height: 34)
                                        
                                        // Toggle circle
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 28, height: 28)
                                            .offset(x: tempIsTempted ? 13 : -13)
                                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom buttons
                    VStack(spacing: 16) {
                        // Save button
                        Button {
                            // Save the data
                            isTempted = tempIsTempted
                            // selectedMoodEmoji is already updated through the computed property
                            isPresented = false
                        } label: {
                            Text("Save")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            tempIsTempted = isTempted
        }
    }
}

#Preview {
    TemptationSheet(
        isPresented: .constant(true),
        isTempted: .constant(false),
        selectedMoodEmoji: .constant("😄")
    )
}
