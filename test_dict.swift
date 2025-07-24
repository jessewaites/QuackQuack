#!/usr/bin/env swift

import Foundation

// Test the exact dictionary from working_version.swift
let emojiKeywords: [String: [String]] = [
    "#️⃣": ["keycap", "number", "sign", "hash", "pound"],
    "*️⃣": ["keycap", "asterisk", "star", "multiply", "symbol"],
    "0️⃣": ["keycap", "digit", "zero", "number", "0"]
    // Just test with a few entries first
]

print("Dictionary created successfully with \(emojiKeywords.count) entries")

// Test filtering like the real app does
let searchTerm = "number"
let filteredEmojis = emojiKeywords.compactMap { (emoji, keywords) -> String? in
    return keywords.contains { $0.lowercased().contains(searchTerm.lowercased()) } ? emoji : nil
}

print("Filtered emojis for '\(searchTerm)': \(filteredEmojis)")