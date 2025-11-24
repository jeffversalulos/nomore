import SwiftUI

struct RelapseView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var consistencyStore: ConsistencyStore
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            // Background - same as other screens
            Color.clear
                .appBackground()
            
            VStack(spacing: 0) {
                // Header section - only back button and title
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    
                    Spacer()
                    
                    Text("Relapsed")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.red)
                    
                    Spacer()
                    
                    Button {
                        // Help action - could show info about relapse recovery
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Scrollable content - constrained to not overlap button
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 64) {
                        // Main message at top of scroll
                        VStack(spacing: 56) {
                            Text("You let yourself\ndown, again.")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            
                            Text("Relapsing can be tough and make you feel awful, but it's crucial not to be too hard on yourself. Doing so can create a vicious cycle, as explained below.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 24)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Relapsing Cycle of Death section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Relapsing Cycle of Death")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Theme.textPrimary)
                                Spacer()
                            }
                            
                            // Cycle items
                            VStack(spacing: 25) {
                                CycleItem(
                                    icon: "hand.point.up.left",
                                    title: "Jerking Off",
                                    description: "In the moment and during orgasm, you feel incredible."
                                )
                                
                                CycleItem(
                                    icon: "eye.trianglebadge.exclamationmark",
                                    title: "Post-Nut Clarity",
                                    description: "Shortly after finishing, the euphoria fades, leaving you with regret, sadness, and depression."
                                )
                                
                                CycleItem(
                                    icon: "arrow.triangle.2.circlepath",
                                    title: "Compensation Cycle",
                                    description: "You masturbate again to alleviate the low feelings, perpetuating the cycle of self-destruction."
                                )
                                
                                CycleItem(
                                    icon: "brain",
                                    title: "Dopamine Depletion",
                                    description: "Each relapse further depletes your dopamine reserves, making it harder to find motivation and joy in everyday activities."
                                )
                                
                                CycleItem(
                                    icon: "heart.slash",
                                    title: "Self-Worth Erosion",
                                    description: "Repeated failures chip away at your self-confidence and belief in your ability to change."
                                )
                                
                                CycleItem(
                                    icon: "person.crop.circle.badge.minus",
                                    title: "Social Withdrawal",
                                    description: "Shame and guilt lead to isolation, reducing your support network when you need it most."
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20) // Just normal bottom padding
                    }
                }
                .padding(.bottom, 45) // Reserve space for the button - reduced for more content space
                
                // Button area - fixed height
                Button {
                    // Reset the streak and close the view
                    streakStore.resetRelapseDate()
                    consistencyStore.recordRelapse()
                    selectedTab = 1 // Navigate to analytics
                    isPresented = false
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Reset Counter")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 34) // Account for safe area
                .frame(height: 100) // Fixed button area height
            }
        }
    }
}

struct CycleItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 32, height: 32)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    @State var isPresented = true
    @State var selectedTab = 0
    
    return RelapseView(isPresented: $isPresented, selectedTab: $selectedTab)
        .environmentObject(StreakStore())
        .environmentObject(ConsistencyStore())
}
