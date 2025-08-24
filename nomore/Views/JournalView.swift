import SwiftUI

struct JournalView: View {
    @EnvironmentObject var journalStore: JournalStore
    @State private var isPresentingComposer: Bool = false
    @State private var draftText: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Custom top bar
                HStack {
                    Text("Journal")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        draftText = ""
                        isPresentingComposer = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.white)
                    }
                    .accessibilityLabel("New Entry")
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 10)

                if journalStore.entries.isEmpty {
                    emptyState
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(journalStore.entries) { entry in
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(entry.date, style: .date)
                                        .font(.footnote)
                                        .foregroundStyle(Theme.textSecondary)
                                    Text(entry.text)
                                        .font(.body)
                                        .foregroundStyle(Theme.textPrimary)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.surface)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .contextMenu {
                                Button(role: .destructive) {
                                    if let index = journalStore.entries.firstIndex(of: entry) {
                                        journalStore.deleteEntry(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    if let index = journalStore.entries.firstIndex(of: entry) {
                                        journalStore.deleteEntry(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.top, 12)
                }
            }
        }
        .appBackground()
        .sheet(isPresented: $isPresentingComposer) {
            composer
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.book.closed")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textSecondary)
            Text("Log what you feel")
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
            Text("Tap the pencil to add your first note.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var composer: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextEditor(text: $draftText)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(Theme.surface)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.surfaceStroke, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresentingComposer = false }
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .principal) {
                    Text("New Entry")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { isPresentingComposer = false; return }
                        journalStore.addEntry(text: trimmed)
                        isPresentingComposer = false
                    }
                    .bold()
                    .foregroundStyle(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(Material.ultraThinMaterial.opacity(0))
        .background {
            Theme.backgroundGradient
                .ignoresSafeArea()
        }
    }
}

#Preview {
    JournalView()
        .environmentObject(JournalStore())
}
