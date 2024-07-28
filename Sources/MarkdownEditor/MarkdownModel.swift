//
//  MarkdownModel.swift
//  Banksia
//
//  Created by Dave Coleman on 20/4/2024.
//

#if os(macOS)



import Foundation
import SwiftUI



extension MarkdownEditorRepresentable {
    
    func setUpTextViewOptions(for textView: MarkdownEditor) {
        
        guard let textContainer = textView.textContainer else { return }
        
        textContainer.containerSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        
        /// If this is set to false, then the text tends to be allowed to run off the right edge,
        /// and less width-related calculations seem to be neccesary
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = false
        
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
                textView.autoresizingMask = [.width]
        
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.isAutomaticTextCompletionEnabled = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = true
        
        textView.wantsScrollEventsForSwipeTracking(on: .none)
        textView.wantsForwardedScrollEvents(for: .none)
        
        
        
        textView.isRichText = false
        textView.importsGraphics = false
        
        textView.insertionPointColor = NSColor(configuration?.insertionPointColour ?? .blue)
        
        textView.smartInsertDeleteEnabled = false
        
        textView.usesFindBar = true
        
        textContainer.lineFragmentPadding = configuration?.paddingX ?? MarkdownDefaults.paddingX
        textView.textContainerInset = NSSize(width: 0, height: configuration?.paddingY ?? MarkdownDefaults.paddingY)
        
        
        textView.maxSize                 = NSSize(width: self.maxWidth, height: CGFloat.greatestFiniteMagnitude)

        
        /// When the text field has an attributed string value, the system ignores the textColor, font, alignment, lineBreakMode, and lineBreakStrategy properties. Set the foregroundColor, font, alignment, lineBreakMode, and lineBreakStrategy properties in the attributed string instead.
        textView.font = NSFont.systemFont(ofSize: configuration?.fontSize ?? MarkdownDefaults.fontSize, weight: MarkdownDefaults.fontWeight)
        
        textView.textColor = NSColor.textColor.withAlphaComponent(MarkdownDefaults.fontOpacity)
        
        textView.isEditable = self.isEditable
        
        textView.drawsBackground = false
        textView.allowsUndo = true
        textView.setNeedsDisplay(textView.bounds)
        //                textView.setNeedsDisplay(NSRect(x: 0, y: 0, width: self.editorWidth ?? 200, height: 200))
    }
    
}



public struct MarkdownDefaults {
    
    public static let defaultFont =               NSFont.systemFont(ofSize: MarkdownDefaults.fontSize, weight: MarkdownDefaults.fontWeight)
    public static let fontSize:                 Double = 15
    public static let fontWeight:               NSFont.Weight = .regular
    public static let fontOpacity:              Double = 0.85
    
    public static let headerSyntaxSize:         Double = 20
    
    public static let fontSizeMono:             Double = 14.5
    
    public static let syntaxAlpha:              Double = 0.3
    public static let backgroundInlineCode:     Double = 0.2
    public static let backgroundCodeBlock:      Double = 0.4
    
    public static let lineSpacing:              Double = 6
    public static let paragraphSpacing:         Double = 0
    
    public static let paddingX: Double = 30
    public static let paddingY: Double = 30
    
}

@MainActor
public enum MarkdownSyntax: String, CaseIterable, Identifiable {
    case h1
    case h2
    case h3
    case bold
    case italic
    case boldItalic
    case strikethrough
    case inlineCode
    case codeBlock
    
    public var id: String {
        self.rawValue
    }
    
    public var name: String {
        self.rawValue
    }
    
    public var iconLiterals: String? {
        switch self {
        case .h1:
            "H1"
        case .h2:
            "H2"
        case .h3:
            "H3"
        case .bold:
            "􀅓"
        case .italic:
            "􀅔"
        case .strikethrough:
            "􀅖"
        case .inlineCode:
            "􀙚"
        case .codeBlock:
            "[]"
        default:
            nil
        }
    }
    
    private static let regexPatterns: [MarkdownSyntax: String] = [
        .h1: "# (.*)",
        .h2: "## (.*)",
        .h3: "### (.*)",
        .bold: "\\*\\*(.*?)\\*\\*",
        .italic: "\\*(.*?)\\*",
        .boldItalic: "\\*\\*\\*(.*?)\\*\\*\\*",
        .strikethrough: "~~(.*?)~~",
        .inlineCode: "`([^\\n`]+)(?!``)`(?!`)",
        .codeBlock: "^\\s*```([\\s\\S]*?)^\\s*```"
    ]
    
    private static let regexCache: [MarkdownSyntax: NSRegularExpression] = {
        var cache = [MarkdownSyntax: NSRegularExpression]()
        for (syntax, pattern) in regexPatterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: syntax == .codeBlock ? .anchorsMatchLines : [])
                cache[syntax] = regex
            } catch {
                print("Error creating regex for \(syntax): \(error)")
            }
        }
        return cache
    }()
    
    public var regex: NSRegularExpression? {
        return MarkdownSyntax.regexCache[self]
    }
    
    public var hideSyntax: Bool {
        switch self {
        case .h1:
            true
        case .h2:
            false
        case .h3:
            false
        case .bold:
            false
        case .italic:
            false
        case .boldItalic:
            false
        case .strikethrough:
            false
        case .inlineCode:
            false
        case .codeBlock:
            false
        }
    }
    
    public var syntaxCharacters: String {
        switch self {
        case .h1:
            "#"
        case .h2:
            "##"
        case .h3:
            "###"
        case .bold:
            "**"
        case .italic:
            "*"
        case .boldItalic:
            "***"
        case .strikethrough:
            "~~"
        case .inlineCode:
            "`"
        case .codeBlock:
            "```"
        }
    }
    public var syntaxSymmetrical: Bool {
        switch self {
        case .h1, .h2, .h3:
            false
        default:
            true
        }
    }
    
    public var shortcut: KeyboardShortcut {
        switch self {
        case .h1:
                .init("1", modifiers: [.command])
        case .h2:
                .init("2", modifiers: [.command])
        case .h3:
                .init("3", modifiers: [.command])
        case .bold:
                .init("b", modifiers: [.command])
        case .italic:
                .init("i", modifiers: [.command])
        case .boldItalic:
                .init("b", modifiers: [.command, .shift])
        case .strikethrough:
                .init("u", modifiers: [.command])
        case .inlineCode:
                .init("c", modifiers: [.command, .option])
        case .codeBlock:
                .init("k", modifiers: [.command, .shift])
        }
    }
    
    public var fontSize: Double {
        switch self {
        case .h1:
            28
        case .h2:
            24
        case .h3:
            18
        case .inlineCode, .codeBlock:
            14
        default: MarkdownDefaults.fontSize
        }
    }
    public var foreGroundColor: NSColor {
        switch self {
        default:
                .textColor.withAlphaComponent(0.85)
        }
    }
    
    public var contentAttributes: [NSAttributedString.Key : Any] {
        
        switch self {
        case .h1:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor
            ]
            
        case .h2:
            
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor
            ]
            
        case .h3:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor
            ]
            
        case .bold:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .bold),
                .foregroundColor: self.foreGroundColor
            ]
            
        case .italic:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let italicDescriptor = bodyDescriptor.withSymbolicTraits(.italic)
            let mediumWeightDescriptor = italicDescriptor.addingAttributes([
                .traits: [
                    NSFontDescriptor.TraitKey.weight: NSFont.Weight.medium
                ]
            ])
            let font = NSFont(descriptor: mediumWeightDescriptor, size: self.fontSize)
            return [
                .font: font as Any,
                .foregroundColor: self.foreGroundColor
            ]
            
        case .boldItalic:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let font = NSFont(descriptor: bodyDescriptor.withSymbolicTraits([.italic, .bold]), size: self.fontSize)
            return [
                .font: font as Any,
                .foregroundColor: self.foreGroundColor
            ]
            
        case .strikethrough:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            
        case .inlineCode:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor,
                .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundInlineCode)
            ]
        case .codeBlock:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: self.foreGroundColor,
                .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundCodeBlock)
            ]
        }
    } // END content attributes
    
    public var syntaxAttributes: [NSAttributedString.Key : Any]  {
        
        switch self {
            
        case .inlineCode:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
                .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha),
                .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundInlineCode)
            ]
        case .codeBlock:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
                .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha),
                .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundCodeBlock)
            ]
        default:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
                .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha)
            ]
        }
    }
}

enum CodeLanguage {
    case swift
    case python
}

#endif
