//
//  File.swift
//  MarkdownEditor
//
//  Created by Dave Coleman on 13/8/2024.
//

import SwiftUI
import STTextKitPlus


extension NSTextView {
  
//  func getLineAndColumnNumber(for range: NSTextRange) -> (line: Int, column: Int)? {
//    
//    
//    
//    let substring = self.string.substring(to: range.location)
//    let lineNumber = substring.components(separatedBy: .newlines).count
//    
//    let lineRange = fullString.lineRange(for: NSRange(location: selectedRange.location, length: 0))
//    let lineStart = lineRange.location
//    let columnNumber = selectedRange.location - lineStart + 1
//    
//    
//  }
  
  func getLineAndColumn(for location: NSTextLocation) -> (line: Int, column: Int)? {
    guard let tlm = self.textLayoutManager,
          let tcm = tlm.textContentManager else {
      return nil
    }
    
//    // Get the line fragment for the given location
//    guard let lineFragment = tlm.textLayoutFragment(for: location) else {
//      return nil
//    }
    
    guard let range = NSTextRange(
      location: tlm.documentRange.location,
      end: tlm.textViewportLayoutController.viewportRange?.location
    ) else { return nil }
    
    let textElements = tcm.textElements(for: range)
    
    return (textElements.count, textElements.count + 2)
//
//    // Calculate line number
//    let lineRange = lineFragment.textLineFragment.rangeInElement
//    let startOfDocument = tcm.documentRange.location
//    let rangeToLine = NSTextRange(location: startOfDocument, end: lineRange.location)
//    let lineNumber = tcm.textLineFragments(for: rangeToLine).count + 1
//    
//    // Calculate column number
//    let columnNumber = textLayoutManager.offset(from: lineRange.location, to: location) + 1
//    
//    return (lineNumber, columnNumber)
  }

  
}
//
//extension NSTextContentManager {
//
//    func location(at offset: Int) -> NSTextLocation? {
//        location(documentRange.location, offsetBy: offset)
//    }
//
//    var length: Int {
//        offset(from: documentRange.location, to: documentRange.endLocation)
//    }
//
//    func location(line lineIdx: Int, character characterIdx: Int? = 0) -> NSTextLocation? {
//        let linesTextElements = textElements(for: documentRange)
//        guard linesTextElements.indices ~= lineIdx else {
//            // https://forums.swift.org/t/invalid-diagnostic-location-after-text-edit/54761
//            // logger.warning("Invalid region line: \(lineIdx). ")
//            return nil
//        }
//
//        guard let startLocation = linesTextElements[lineIdx].elementRange?.location else {
//            return nil
//        }
//
//        return location(startLocation, offsetBy: characterIdx ?? 0)
//    }
//
//    func position(_ location: NSTextLocation) -> (row: Int, column: Int)? {
//        let linesElements = textElements(for: documentRange)
//        if linesElements.isEmpty {
//            return nil
//        }
//
//        let lineIdx: Int?
//        if location == documentRange.endLocation {
//            lineIdx = max(0, linesElements.count - 1)
//        } else if let foundLineIdx = linesElements.firstIndex(where: { $0.elementRange!.contains(location) }) {
//            lineIdx = foundLineIdx
//        } else {
//            lineIdx = nil
//        }
//
//        guard let lineIdx else {
//            return nil
//        }
//
//        let column = offset(from: linesElements[lineIdx].elementRange!.location, to: location)
//        return (row: lineIdx, column: column)
//    }
//
//    /// Attributed string for the range
//    /// - Parameter range: Text range, or nil for the whole document.
//    /// - Returns: Attributed string, or nil.
//    func attributedString(in range: NSTextRange?) -> NSAttributedString? {
//        if let range, range.isEmpty {
//            return nil
//        }
//
//        // fast path
//        if let textContentStorage = self as? NSTextContentStorage {
//            if let range {
//                return textContentStorage.textStorage?.attributedSubstring(from: NSRange(range, in: self))
//            } else {
//                return textContentStorage.textStorage
//            }
//        }
//
//        // slow path
//        let result = NSMutableAttributedString()
//        result.beginEditing()
//        enumerateTextElements(from: range?.location) { textElement in
//            if let range = range,
//               let textParagraph = textElement as? NSTextParagraph,
//               let elementRange = textElement.elementRange,
//               let textContentManager = textElement.textContentManager
//            {
//                var shouldStop = false
//                var needAdjustment = false
//                var constrainedElementRange = elementRange
//                if elementRange.contains(range.location) {
//                    // start location
//                    constrainedElementRange = NSTextRange(location: range.location, end: constrainedElementRange.endLocation)!
//                    needAdjustment = true
//                }
//
//                if elementRange.contains(range.endLocation) {
//                    // end location
//                    constrainedElementRange = NSTextRange(location: constrainedElementRange.location, end: range.endLocation)!
//                    needAdjustment = true
//                    shouldStop = true
//                }
//
//                if needAdjustment {
//                    if let constrainedRangeInDocument = NSTextRange(location: constrainedElementRange.location, end: constrainedElementRange.endLocation) {
//                        let constrainedRangeInDocumentLength = constrainedRangeInDocument.length(in: textContentManager)
//                        let leadingOffset = textContentManager.offset(from: elementRange.location, to: constrainedElementRange.location)
//
//                        // translate contentRangeInDocument from document namespace to textElement.attributedString namespace
//                        let nsRangeInDocumentDocument = NSRange(
//                            location: leadingOffset,
//                            length: constrainedRangeInDocumentLength
//                        )
//
//                        result.append(
//                            textParagraph.attributedString.attributedSubstring(from: nsRangeInDocumentDocument)
//                        )
//                    }
//                } else {
//                    result.append(
//                        textParagraph.attributedString
//                    )
//                }
//
//                if shouldStop {
//                    return false
//                }
//            } else if range == nil, let textParagraph = textElement as? NSTextParagraph {
//                result.append(
//                    textParagraph.attributedString
//                )
//            }
//
//            return true
//        }
//
//        result.fixAttributes(in: NSRange(location: 0, length: result.length))
//        result.endEditing()
//        if result.length == 0 {
//            return nil
//        }
//
//        return result
//    }
//}
//
//

//
//extension NSTextContentManager {
//  
//  /// Attributes at location
//  func attributes(at location: NSTextLocation) -> [NSAttributedString.Key: Any] {
//    guard !documentRange.isEmpty else {
//      return [:]
//    }
//    
//    let effectiveLocation: NSTextLocation
//    if location == documentRange.location {
//      effectiveLocation = location
//    } else if location == documentRange.endLocation {
//      effectiveLocation = self.location(location, offsetBy: -1) ?? location
//    } else {
//      effectiveLocation = location
//    }
//    
//    // requires non-empty range
//    return attributedString(
//      in: NSTextRange(
//        location: effectiveLocation,
//        end: self.location(effectiveLocation, offsetBy: 1)
//      )
//    )?.attributes(
//      at: 0,
//      effectiveRange: nil
//    ) ?? [:]
//  }
//  
//  
//}
