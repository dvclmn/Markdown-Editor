//
//  EditorInfo.swift
//  MarkdownEditor
//
//  Created by Dave Coleman on 14/8/2024.
//

import SwiftUI

public struct EditorInfo: Sendable {
  
  public struct Text: Sendable {
    var editorHeight: CGFloat = .zero
    var characterCount: Int = 0
    var textElementCount: Int = 0 // TextElement seems to equate to a paragraph
    var codeBlocks: Int = 0
    var documentRange: String = ""
    var viewportRange: String = ""
  }
  
  public struct Selection: Sendable {
    var selection: String = ""
//  var selectedRange: NSTextRange?
    var selectedSyntax: [Markdown.Syntax] = []
    var lineNumber: Int? = nil
    var columnNumber: Int? = nil
  }
  
  public struct Scroll: Sendable {
    var summary: String = ""
  }
}
