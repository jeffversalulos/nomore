import SwiftUI

struct PanickingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var consistencyStore: ConsistencyStore
    @State private var showRelapseView = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button and title
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("ANEW")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .tracking(2)
                        
                        Text("Panic Button")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: Help/Info action
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Main content in scroll view
                ScrollView {
                    VStack(spacing: 20) {
                        // Camera section
                        SelfReflectionCamera()
                            .padding(.top, 20)
                        
                        // Message overlay (positioned to overlap camera bottom)
                        RelapsingMessage()
                            .offset(y: -40)
                        
                        // Side effects section
                        SideEffectsSection()
                            .padding(.top, -20)
                        
                        // Extra padding for bottom buttons
                        Spacer()
                            .frame(height: 120)
                    }
                }
                
                Spacer()
            }
            
            // Sticky bottom buttons
            VStack {
                Spacer()
                PanicBottomButtons(
                    onIRelapsed: {
                        showRelapseView = true
                    },
                    onThinkingOfRelapsing: {
                        // TODO: Handle "I'm thinking of relapsing" action
                        print("I'm thinking of relapsing tapped")
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showRelapseView) {
            RelapseView(isPresented: $showRelapseView, selectedTab: $selectedTab)
                .environmentObject(streakStore)
                .environmentObject(consistencyStore)
        }
    }
}

#Preview {
    PanickingView()
        .environmentObject(StreakStore())
        .environmentObject(ConsistencyStore())
}
