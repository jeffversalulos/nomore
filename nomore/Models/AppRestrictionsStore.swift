import Foundation
import SwiftUI
import FamilyControls
import ManagedSettings

/// Manages app restriction settings and persistence for the Internet Filter feature.
/// Handles FamilyActivitySelection persistence and ManagedSettingsStore configuration.
final class AppRestrictionsStore: ObservableObject {
    @Published var isContentRestrictionsEnabled: Bool = false
    @Published var activitySelection = FamilyActivitySelection()
    
    private let managedSettingsStore = ManagedSettingsStore()
    private let defaults = UserDefaults.standard
    
    // UserDefaults keys
    private let contentRestrictionsEnabledKey = "isContentRestrictionsEnabled"
    private let hasActiveRestrictionsKey = "hasActiveAppRestrictions"
    
    init() {
        loadSettings()
    }
    
    // MARK: - Public Methods
    
    /// Updates the content restrictions toggle state and persists it
    func setContentRestrictionsEnabled(_ enabled: Bool) {
        isContentRestrictionsEnabled = enabled
        defaults.set(enabled, forKey: contentRestrictionsEnabledKey)
        
        // If disabling, clear all restrictions
        if !enabled {
            clearAllRestrictions()
        }
    }
    
    /// Updates the activity selection and applies restrictions
    func updateActivitySelection(_ selection: FamilyActivitySelection) {
        activitySelection = selection
        applyAppRestrictions(selection: selection)
        
        // Track if we have any active restrictions
        let hasRestrictions = !selection.applicationTokens.isEmpty || 
                             !selection.categoryTokens.isEmpty || 
                             !selection.webDomainTokens.isEmpty
        defaults.set(hasRestrictions, forKey: hasActiveRestrictionsKey)
    }
    
    /// Gets whether there are any active restrictions
    var hasActiveRestrictions: Bool {
        defaults.bool(forKey: hasActiveRestrictionsKey)
    }
    
    /// Clears all restrictions and resets state
    func clearAllRestrictions() {
        // Clear the managed settings
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil
        managedSettingsStore.shield.webDomains = nil
        
        // Reset the activity selection
        activitySelection = FamilyActivitySelection()
        
        // Clear persistence flags
        defaults.set(false, forKey: hasActiveRestrictionsKey)
        
        print("Cleared all app restrictions")
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        // Load the content restrictions toggle state
        isContentRestrictionsEnabled = defaults.bool(forKey: contentRestrictionsEnabledKey)
        
        // Restore the FamilyActivitySelection from ManagedSettingsStore
        // The actual restrictions persist in ManagedSettingsStore, so we can reconstruct
        // the selection from what's currently active
        restoreActivitySelectionFromManagedSettings()
    }
    
    private func restoreActivitySelectionFromManagedSettings() {
        // Reconstruct the FamilyActivitySelection from what's currently active in ManagedSettingsStore
        var restoredSelection = FamilyActivitySelection()
        
        // Restore application tokens
        if let applications = managedSettingsStore.shield.applications {
            restoredSelection.applicationTokens = applications
        }
        
        // Restore category tokens
        if case let .specific(categories, except: _) = managedSettingsStore.shield.applicationCategories {
            restoredSelection.categoryTokens = categories
        }
        
        // Restore web domain tokens
        if let webDomains = managedSettingsStore.shield.webDomains {
            restoredSelection.webDomainTokens = webDomains
        }
        
        // Update the activity selection if we found any active restrictions
        let hasActiveRestrictions = !restoredSelection.applicationTokens.isEmpty || 
                                   !restoredSelection.categoryTokens.isEmpty || 
                                   !restoredSelection.webDomainTokens.isEmpty
        
        if hasActiveRestrictions {
            activitySelection = restoredSelection
            // Update the UserDefaults flag to match the restored state
            defaults.set(true, forKey: hasActiveRestrictionsKey)
            print("Restored \(restoredSelection.applicationTokens.count) apps, \(restoredSelection.categoryTokens.count) categories, and \(restoredSelection.webDomainTokens.count) web domains from ManagedSettingsStore")
        } else {
            // Ensure the flag is correct if no restrictions are active
            defaults.set(false, forKey: hasActiveRestrictionsKey)
        }
    }
    
    private func applyAppRestrictions(selection: FamilyActivitySelection) {
        // Only apply restrictions if content restrictions are enabled
        guard isContentRestrictionsEnabled else { return }
        
        // Apply app restrictions using ManagedSettingsStore
        managedSettingsStore.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        managedSettingsStore.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        managedSettingsStore.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        
        print("Applied restrictions to \(selection.applicationTokens.count) apps, \(selection.categoryTokens.count) categories, and \(selection.webDomainTokens.count) web domains")
    }
}
