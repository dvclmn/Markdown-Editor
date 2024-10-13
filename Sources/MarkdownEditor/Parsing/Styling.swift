//
//  Styling.swift
//  MarkdownEditor
//
//  Created by Dave Coleman on 8/10/2024.
//

import AppKit
//import Highlightr
import Glyph

extension MarkdownTextView {
  
  func styleInlineMarkdown() {
    
    let currentSelection = self.selectedRange
    
    self.styleElement()
    //          self.needsDisplay = true
    
    self.setSelectedRange(currentSelection)

  } // END style debounced
  
  
  func styleElement() {
    
    //    guard let layoutManager = self.layoutManager else {
    //      fatalError("Issue getting the layout manager")
    //
    //    }
    
    guard let textStorage = self.textStorage else {
      fatalError("Issue getting the text storage")
    }
    
    let opacity: CGFloat = 0.15
    
    let leadingTestColour = NSColor.orange.withAlphaComponent(opacity)
    let contentTestColour = NSColor.blue.withAlphaComponent(opacity)
    let trailingTestColour = NSColor.green.withAlphaComponent(opacity)

    tcm.performEditingTransaction {
      
      for element in self.elements where element.syntax.type == .inline {
        
        /// This is a bit silly, I'm writing this as if the user has pressed Return
        /// (i.e., departed one paragraph and arrived at another)
        ///
//        let rangeToRemoveDeparted: NSRange = self.paragraphHandler.previousParagraph.range
//        let rangeToRemoveArrived: NSRange = self.paragraphHandler.currentParagraph.range
//        
//        /// Remove stale attributes
//        textStorage.removeAttribute(.foregroundColor, range: rangeToRemoveDeparted)
//        textStorage.removeAttribute(.foregroundColor, range: rangeToRemoveArrived)
//        
//        textStorage.removeAttribute(.backgroundColor, range: rangeToRemoveDeparted)
//        textStorage.removeAttribute(.backgroundColor, range: rangeToRemoveArrived)
//        
//        /// Add default styles
//        textStorage.setAttributes(configuration.defaultTypingAttributes, range: rangeToRemoveArrived)
//        textStorage.setAttributes(configuration.defaultTypingAttributes, range: rangeToRemoveDeparted)
//
        
        
        
        textStorage.addAttribute(.backgroundColor, value: leadingTestColour, range: element.ranges.leading)
        textStorage.addAttribute(.backgroundColor, value: contentTestColour, range: element.ranges.content)
        textStorage.addAttribute(.backgroundColor, value: trailingTestColour, range: element.ranges.trailing)

        
        
        
        if element.syntax == .codeBlock {
          
          textStorage.addAttribute(.font, value: configuration.theme.codeFont, range: element.ranges.all)
          
          
          
//          guard let highlightedCode: NSAttributedString = highlightr.highlight(element.string, as: nil) else {
//            print("Couldn't get the Highlighted string")
//            return
//          }
//          
//          highlightedCode.enumerateAttribute(.foregroundColor, in: documentNSRange) { value, range, stop in
//            
//            if let color = value as? NSColor {
//              textStorage.addAttribute(.foregroundColor, value: color, range: range)
//            }
//            
//          }
        } else {
          
          
          
//          textStorage.addAttributes(element.syntax.contentAttributes(with: self.configuration).attributes, range: element.ranges.content)
//          
//          textStorage.addAttributes(element.syntax.syntaxAttributes(with: self.configuration).attributes, range: element.ranges.leading)
//          textStorage.addAttributes(element.syntax.syntaxAttributes(with: self.configuration).attributes, range: element.ranges.trailing)
          
        }
        
          
//          textStorage.replaceCharacters(in: element.range, with: highlightedCode)

      } // END elements loop

      
    } // END perform editing

    
  } // END styling
  
}
