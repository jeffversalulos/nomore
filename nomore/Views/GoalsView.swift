//
//  Goals.swift
//  nomore
//
//  Created by Aa on 2025-08-14.
//

import SwiftUI
import PhotosUI

struct GoalsView: View {
    @EnvironmentObject var goalsStore: GoalsStore
    @State private var showingAddGoal = false
    @State private var showingSelectedGoals = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                        
                        if !goalsStore.selectedGoals.isEmpty {
                            selectedGoalsSection
                        }
                        
                        availableGoalsSection
                        
                        addCustomGoalButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Your Goals")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddGoal) {
                AddGoalSheet()
                    .environmentObject(goalsStore)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "target")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Theme.accent)
            
            Text("Why did you start this journey?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Select the goals that motivate you most. They'll remind you why this matters.")
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.bottom, 8)
    }
    
    private var selectedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Selected Goals")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
                
                Text("\(goalsStore.selectedGoals.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            let selectedGoals = goalsStore.selectedGoals
            ForEach(0..<(selectedGoals.count + 1) / 2, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    let leftIndex = rowIndex * 2
                    let rightIndex = leftIndex + 1
                    
                    if leftIndex < selectedGoals.count {
                        GoalCard(goal: selectedGoals[leftIndex], isSelected: true) {
                            withAnimation(.spring(response: 0.4)) {
                                goalsStore.toggleGoalSelection(selectedGoals[leftIndex])
                            }
                        }
                    }
                    
                    if rightIndex < selectedGoals.count {
                        GoalCard(goal: selectedGoals[rightIndex], isSelected: true) {
                            withAnimation(.spring(response: 0.4)) {
                                goalsStore.toggleGoalSelection(selectedGoals[rightIndex])
                            }
                        }
                    } else if leftIndex < selectedGoals.count {
                        // Add spacer for odd number of items
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var availableGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Goals")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
            
            let availableGoals = goalsStore.goals.filter { !$0.isSelected }
            ForEach(0..<(availableGoals.count + 1) / 2, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    let leftIndex = rowIndex * 2
                    let rightIndex = leftIndex + 1
                    
                    if leftIndex < availableGoals.count {
                        GoalCard(goal: availableGoals[leftIndex], isSelected: false) {
                            withAnimation(.spring(response: 0.4)) {
                                goalsStore.toggleGoalSelection(availableGoals[leftIndex])
                            }
                        }
                    }
                    
                    if rightIndex < availableGoals.count {
                        GoalCard(goal: availableGoals[rightIndex], isSelected: false) {
                            withAnimation(.spring(response: 0.4)) {
                                goalsStore.toggleGoalSelection(availableGoals[rightIndex])
                            }
                        }
                    } else if leftIndex < availableGoals.count {
                        // Add spacer for odd number of items
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var addCustomGoalButton: some View {
        Button {
            showingAddGoal = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Add Custom Goal")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Create your own personal motivation")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.surfaceStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.top, 8)
    }
}

struct GoalCard: View {
    let goal: Goal
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon or Image
                if let imageData = goal.customImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else if let systemImage = goal.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(isSelected ? Theme.accent : Theme.textSecondary)
                }
                
                VStack(spacing: 4) {
                    Text(goal.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(goal.description)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.accent)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(16)
            .background(isSelected ? Theme.accent.opacity(0.1) : Theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Theme.accent.opacity(0.6) : Theme.surfaceStroke, lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

struct AddGoalSheet: View {
    @EnvironmentObject var goalsStore: GoalsStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Image selection
                    VStack(spacing: 16) {
                        if let imageData = imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Theme.surfaceStroke, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "photo.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Text(imageData == nil ? "Add Photo" : "Change Photo")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    
                    // Text fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal Title")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("e.g., Be Present for My Family", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why This Matters")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("Describe what motivates you about this goal", text: $description, axis: .vertical)
                                .lineLimit(3...6)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    Spacer()
                    
                    // Save button
                    Button {
                        addGoal()
                    } label: {
                        Text("Add Goal")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(title.isEmpty ? Theme.surface : Theme.accent)
                            .foregroundStyle(Theme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .disabled(title.isEmpty)
                }
                .padding(20)
            }
            .navigationTitle("Add Custom Goal")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .onChange(of: selectedImage) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        imageData = data
                    }
                }
            }
        }
    }
    
    private func addGoal() {
        goalsStore.addCustomGoal(
            title: title,
            description: description,
            imageData: imageData
        )
        dismiss()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Theme.surface)
            .foregroundStyle(Theme.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Theme.surfaceStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    GoalsView()
        .environmentObject(GoalsStore())
}
