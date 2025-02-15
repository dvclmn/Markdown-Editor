//
//  MainView.swift
//  MarkdownEditor
//
//  Created by Dave Coleman on 10/2/2025.
//

import AppKit

import TreeSitterMarkdown
import TreeSitterMarkdownInline
import TreeSitterSwift
import SwiftTreeSitter
import Neon

@MainActor
public class MarkdownController: NSViewController {

  let textView: NSTextView
  private let highlighter: TextViewHighlighter

  public init(configuration: EditorConfiguration) {
    
    textView = NSTextView(usingTextLayoutManager: false)
//    /// Create text storage and layout manager
//    let textStorage = NSTextStorage()
//    let layoutManager = NSLayoutManager()
////    let layoutManager = MarkdownLayoutManager(configuration: configuration)
//    textStorage.addLayoutManager(layoutManager)
//
//    /// Create text container
//    let textContainer = NSTextContainer()
//    textContainer.widthTracksTextView = true
//    layoutManager.addTextContainer(textContainer)
//    
//    /// Create text view
//    textView = MarkdownTextView(
//      frame: .zero,
//      textContainer: textContainer,
//      configuration: configuration
//    )
//    
//    scrollView = NSScrollView()
//    scrollView.hasVerticalScroller = textView.configuration.isEditable
//    scrollView.drawsBackground = false
//    scrollView.documentView = textView
    do {
      self.highlighter = try Self.makeHighlighter(
        for: textView,
        with: configuration
      )
      super.init(nibName: nil, bundle: nil)
      
      if textView.textLayoutManager == nil {
        textView.layoutManager?.allowsNonContiguousLayout = true
      }
      
    } catch {
      fatalError("Error starting `TextViewHighlighter`: \(error)")
    }
    
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    
    let scrollView = NSScrollView()
    scrollView.hasVerticalScroller = true
    
    let max = CGFloat.greatestFiniteMagnitude
    textView.minSize = NSSize.zero
    textView.maxSize = NSSize(width: max, height: max)
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = true
    
    // Configure text container to match scroll view's width
    if let textContainer = textView.textContainer {
      textContainer.containerSize = NSSize(width: max, height: max)
      textContainer.widthTracksTextView = true
    }
    
    scrollView.documentView = textView
    self.view = scrollView
    
    
    
//    let scrollView = NSScrollView()
//    
//    scrollView.hasVerticalScroller = true
//    scrollView.documentView = textView
//    
//    let max = CGFloat.greatestFiniteMagnitude
//    
//    textView.minSize = NSSize.zero
//    textView.maxSize = NSSize(width: max, height: max)
//    textView.isVerticallyResizable = true
//    textView.isHorizontallyResizable = true
//    
//    textView.isRichText = false  // Discards any attributes when pasting.
//    
//    self.view = scrollView
//    
//    textView.enclosingScrollView
//    
////    self.view = scrollView
//    highlighter.observeEnclosingScrollView()

  }
  
  public override func viewDidAppear() {
    super.viewDidAppear()
    // Move the highlighter observation here
    highlighter.observeEnclosingScrollView()
  }
  
  public override func viewWillLayout() {
    super.viewWillLayout()
    // Ensure proper sizing
    if let scrollView = view as? NSScrollView {
      textView.frame = scrollView.contentView.bounds
    }
  }

}



//@MainActor
//final class TextViewController: NSUIViewController {
//  private let textView: NSUITextView
//  private let highlighter: TextViewHighlighter
//  
//  init() {
//    self.textView = NSUITextView(usingTextLayoutManager: false)
//    
//    self.highlighter = try! Self.makeHighlighter(for: textView)
//    
//    super.init(nibName: nil, bundle: nil)
//    
//    // enable non-continguous layout for TextKit 1
//    if textView.textLayoutManager == nil {
//      textView.nsuiLayoutManager?.allowsNonContiguousLayout = true
//    }
//  }
//  
//  @available(*, unavailable)
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  private static func makeHighlighter(for textView: NSUITextView) throws -> TextViewHighlighter {
//    let regularFont = NSUIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
//    let boldFont = NSUIFont.monospacedSystemFont(ofSize: 16, weight: .bold)
//    let italicDescriptor = regularFont.fontDescriptor.nsuiWithSymbolicTraits(.traitItalic) ?? regularFont.fontDescriptor
//    
//    let italicFont = NSUIFont(nsuiDescriptor: italicDescriptor, size: 16) ?? regularFont
//    
//    // Set the default styles. This is applied by stock `NSTextStorage`s during
//    // so-called "attribute fixing" when you type, and we emulate that as
//    // part of the highlighting process in `TextViewSystemInterface`.
//    textView.typingAttributes = [
//      .foregroundColor: NSUIColor.darkGray,
//      .font: regularFont,
//    ]
//    
//    let provider: TokenAttributeProvider = { token in
//      return switch token.name {
//        case let keyword where keyword.hasPrefix("keyword"): [.foregroundColor: NSUIColor.red, .font: boldFont]
//        case "comment", "spell": [.foregroundColor: NSUIColor.green, .font: italicFont]
//          // Note: Default is not actually applied to unstyled/untokenized text.
//        default: [.foregroundColor: NSUIColor.blue, .font: regularFont]
//      }
//    }
//    
//    // this is doing both synchronous language initialization everything, but TreeSitterClient supports lazy loading for embedded languages
//    let markdownConfig = try! LanguageConfiguration(
//      tree_sitter_markdown(),
//      name: "Markdown"
//    )
//    
//    let markdownInlineConfig = try! LanguageConfiguration(
//      tree_sitter_markdown_inline(),
//      name: "MarkdownInline",
//      bundleName: "TreeSitterMarkdown_TreeSitterMarkdownInline"
//    )
//    
//    let swiftConfig = try! LanguageConfiguration(
//      tree_sitter_swift(),
//      name: "Swift"
//    )
//    
//    let highlighterConfig = TextViewHighlighter.Configuration(
//      languageConfiguration: swiftConfig, // the root language
//      attributeProvider: provider,
//      languageProvider: { name in
//        print("embedded language: ", name)
//        
//        switch name {
//          case "swift":
//            return swiftConfig
//          case "markdown_inline":
//            return markdownInlineConfig
//          default:
//            return nil
//        }
//      },
//      locationTransformer: { _ in nil }
//    )
//    
//    return try TextViewHighlighter(textView: textView, configuration: highlighterConfig)
//  }
//  
//  override func loadView() {
//#if canImport(AppKit) && !targetEnvironment(macCatalyst)
//    let scrollView = NSScrollView()
//    
//    scrollView.hasVerticalScroller = true
//    scrollView.documentView = textView
//    
//    let max = CGFloat.greatestFiniteMagnitude
//    
//    textView.minSize = NSSize.zero
//    textView.maxSize = NSSize(width: max, height: max)
//    textView.isVerticallyResizable = true
//    textView.isHorizontallyResizable = true
//    
//    textView.isRichText = false  // Discards any attributes when pasting.
//    
//    self.view = scrollView
//#else
//    self.view = textView
//#endif
//    
//    // this has to be done after the textview has been embedded in the scrollView if
//    // it wasn't that way on creation
//    highlighter.observeEnclosingScrollView()
//    
//    regularTestWithSwiftCode()
//  }
//  
//  func regularTestWithSwiftCode() {
//    let url = Bundle.main.url(forResource: "test", withExtension: "code")!
//    let content = try! String(contentsOf: url)
//    
//    textView.text = content
//  }
//  
//  func doBigMarkdownTest() {
//    let url = Bundle.main.url(forResource: "big_test", withExtension: "md")!
//    let content = try! String(contentsOf: url)
//    
//    textView.text = content
//    
//    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//      let range = NSRange(location: content.utf16.count, length: 0)
//      
//      self.textView.scrollRangeToVisible(range)
//    }
//  }
//}
