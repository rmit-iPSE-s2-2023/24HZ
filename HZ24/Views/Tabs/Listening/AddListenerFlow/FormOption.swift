//
// FormOption.swift
// HZ24
// 
// Created by jin on 2023-10-11
// 



import SwiftUI

/// A view for displaying an option in a form.
///
/// - Parameters:
///   - optionText: Description of option. Can be in markdown format.
///   - isSelected: If true, the view will be highlighted with an accent background and a checkmark.
struct FormOption: View {
    
    var optionText: String
    var isSelected: Bool
    
    private func textAsMarkdown() -> AttributedString {
        do {
            return try AttributedString(markdown: optionText)
        } catch {
            return AttributedString(stringLiteral: optionText)
        }
    }
    
    // MARK: - Return body
    var body: some View {
        ZStack {
            // Background rectangle with rounded corners
            Text(textAsMarkdown())
            
            if isSelected {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .padding(2)
                    }
                    Spacer()
                }
            }
        }
        .foregroundColor(isSelected ? Color.init(uiColor: .systemBackground) : .accentColor)
        .font(.title2)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(isSelected ? Color.accentColor : .secondary.opacity(0.2))
        .cornerRadius(13)
        // End of ZStack (parent)
    }
}

// MARK: - Previews
struct FormOption_Previews: PreviewProvider {
    static var previews: some View {
        FormOption(optionText: "Listen for **new token** releases", isSelected: true)
    }
}
