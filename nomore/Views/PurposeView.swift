//
//  PurposeView.swift
//  nomore
//
//  Created by Aa on 2025-08-14.
//

import SwiftUI
import PhotosUI

struct PurposeView: View {
    @EnvironmentObject var purposeStore: PurposeStore
    @State private var showingAddPurpose = false
    @State private var showingSelectedPurposes = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                
                if !purposeStore.selectedPurposes.isEmpty {
                    selectedPurposesSection
                }
                
                availablePurposesSection
                
                addCustomPurposeButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) // Add bottom padding to account for the custom tab bar
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAddPurpose) {
            AddPurposeSheet()
                .environmentObject(purposeStore)
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
            
            Text("Select the purposes that motivate you most. They'll remind you why this matters.")
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.bottom, 8)
    }
    
    private var selectedPurposesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Selected Purposes")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
                
                Text("\(purposeStore.selectedPurposes.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            let selectedPurposes = purposeStore.selectedPurposes
            ForEach(0..<(selectedPurposes.count + 1) / 2, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    let leftIndex = rowIndex * 2
                    let rightIndex = leftIndex + 1
                    
                    if leftIndex < selectedPurposes.count {
                        PurposeCard(purpose: selectedPurposes[leftIndex], isSelected: true) {
                            withAnimation(.spring(response: 0.4)) {
                                purposeStore.togglePurposeSelection(selectedPurposes[leftIndex])
                            }
                        }
                    }
                    
                    if rightIndex < selectedPurposes.count {
                        PurposeCard(purpose: selectedPurposes[rightIndex], isSelected: true) {
                            withAnimation(.spring(response: 0.4)) {
                                purposeStore.togglePurposeSelection(selectedPurposes[rightIndex])
                            }
                        }
                    } else if leftIndex < selectedPurposes.count {
                        // Add spacer for odd number of items
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var availablePurposesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Purposes")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
            
            let availablePurposes = purposeStore.purposes.filter { !$0.isSelected }
            ForEach(0..<(availablePurposes.count + 1) / 2, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    let leftIndex = rowIndex * 2
                    let rightIndex = leftIndex + 1
                    
                    if leftIndex < availablePurposes.count {
                        PurposeCard(purpose: availablePurposes[leftIndex], isSelected: false) {
                            withAnimation(.spring(response: 0.4)) {
                                purposeStore.togglePurposeSelection(availablePurposes[leftIndex])
                            }
                        }
                    }
                    
                    if rightIndex < availablePurposes.count {
                        PurposeCard(purpose: availablePurposes[rightIndex], isSelected: false) {
                            withAnimation(.spring(response: 0.4)) {
                                purposeStore.togglePurposeSelection(availablePurposes[rightIndex])
                            }
                        }
                    } else if leftIndex < availablePurposes.count {
                        // Add spacer for odd number of items
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var addCustomPurposeButton: some View {
        Button {
            showingAddPurpose = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Add Custom Purpose")
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
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .softShadow()
        }
        .padding(.top, 8)
    }
}

struct PurposeCard: View {
    let purpose: Purpose
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon or Image
                if let imageData = purpose.customImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else if let systemImage = purpose.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(isSelected ? Theme.accent : Theme.textSecondary)
                }
                
                VStack(spacing: 4) {
                    Text(purpose.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(purpose.description)
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
            .softShadow()
        }
        .buttonStyle(.plain)
    }
}

struct AddPurposeSheet: View {
    @EnvironmentObject var purposeStore: PurposeStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View {
        ZStack {
            // Background image applied at the root level
            Image("BG")
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .ignoresSafeArea()
            
            NavigationView {
                ZStack {
                    // Clear color background to ensure no white shows
                    Color.clear
                        .ignoresSafeArea()
                    
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
                            Text("Purpose Title")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("e.g., Be Present for My Family", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why This Matters")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("Describe what motivates you about this purpose", text: $description, axis: .vertical)
                                .lineLimit(3...6)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    Spacer()
                    
                    // Save button
                    Button {
                        addPurpose()
                    } label: {
                        Text("Add Purpose")
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
                .navigationTitle("Add Custom Purpose")
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
    
    private func addPurpose() {
        purposeStore.addCustomPurpose(
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
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    PurposeView()
        .environmentObject(PurposeStore())
}
