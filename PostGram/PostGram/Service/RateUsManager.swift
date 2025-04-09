//
//  RateUsManager.swift
//  XScanner
//
//  Created by Mert Türedü on 17.02.2025.
//


import StoreKit
import SwiftUI

final class RateUsManager: ObservableObject {
    
    static let shared: RateUsManager = .init()
    @Published var shouldShowRateUs: Bool = false
    
    // User defaults keys
    private let lastPromptDateKey = "lastRatePromptDate"
    private let promptCountKey = "ratePromptCount"
    private let hasRatedKey = "hasRatedApp"
    
    // Configuration
    private let minimumDaysBetweenPrompts: Double = 7 // Minimum days between prompts
    private let maxPromptCount: Int = 3 // Maximum number of times to show prompt
    
    init() {
        checkIfShouldShowRateUs()
    }
    
    func checkIfShouldShowRateUs() {
        // If user has already rated, don't show again
        guard !UserDefaults.standard.bool(forKey: hasRatedKey) else {
            return
        }
        
        let promptCount = UserDefaults.standard.integer(forKey: promptCountKey)
        
        // Check if we've reached max prompt count
        guard promptCount < maxPromptCount else {
            return
        }
        
        // Check if enough time has passed since last prompt
        if let lastPromptDate = UserDefaults.standard.object(forKey: lastPromptDateKey) as? Date {
            let daysSinceLastPrompt = Calendar.current.dateComponents([.day], from: lastPromptDate, to: Date()).day ?? 0
            guard Double(daysSinceLastPrompt) >= minimumDaysBetweenPrompts else {
                return
            }
        }
        
        shouldShowRateUs = true
    }
    
    func requestReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        // Increment prompt count
        let currentCount = UserDefaults.standard.integer(forKey: promptCountKey)
        UserDefaults.standard.set(currentCount + 1, forKey: promptCountKey)
        
        // Update last prompt date
        UserDefaults.standard.set(Date(), forKey: lastPromptDateKey)
        
        // Request review
        SKStoreReviewController.requestReview(in: windowScene)
        
        // Reset shouldShowRateUs
        shouldShowRateUs = false
    }
    
    func markAsRated() {
        UserDefaults.standard.set(true, forKey: hasRatedKey)
        shouldShowRateUs = false
    }
    
    func resetRateUsStatus() {
        UserDefaults.standard.removeObject(forKey: hasRatedKey)
        UserDefaults.standard.removeObject(forKey: promptCountKey)
        UserDefaults.standard.removeObject(forKey: lastPromptDateKey)
    }
}
