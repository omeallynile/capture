import Foundation
import Observation
import NaturalLanguage

@Observable
class AIProcessingManager {
    enum Status {
        case idle
        case processing
        case success
        case failed
    }

    var status: Status = .idle
    var smartTags: [String] = []

    // Simulate NLP Entity Extraction
    func analyzeText(_ text: String) async -> [String] {
        guard !text.isEmpty else { return [] }

        status = .processing
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Mock logic: Just split by spaces and check for capitalized words as "entities"
        let words = text.split(separator: " ").map(String.init)
        let entities = words.filter { $0.first?.isUppercase == true && $0.count > 1 }

        // Also add some predefined mock tags based on keywords
        var tags = entities
        if text.lowercased().contains("wrecker") { tags.append("Car Parts") }
        if text.lowercased().contains("receipt") { tags.append("Finance") }

        status = .success
        smartTags = tags
        return tags
    }

    // Simulate Vision Text Recognition
    func analyzeImage(_ imageData: Data) async -> String {
        // Mock OCR result
        return "Receipt #12345\nTotal: $42.00"
    }
}
