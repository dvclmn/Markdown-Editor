//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//

import SwiftUI
import STTextKitPlus


public class MarkdownTextView: NSTextView {
  
  private var viewportLayoutController: NSTextViewportLayoutController?
  private var viewportDelegate: CustomViewportDelegate?
  
  var isShowingFrames: Bool
  var textInsets: CGFloat
  
  //  var inlineCodeElements: [InlineCodeElement] = []
  
  var markdownBlocks: [MarkdownBlock] = []
  
  public typealias OnEvent = (_ event: NSEvent, _ action: () -> Void) -> Void
  
  private var activeScrollValue: (NSRange, CGSize)?
  
  var lastSelectionValue = [NSValue]()
  var lastTextValue = String()
  
  public var onKeyDown: OnEvent = { $1() }
  public var onFlagsChanged: OnEvent = { $1() }
  public var onMouseDown: OnEvent = { $1() }
  
  public var onTextChange: MarkdownEditor.TextInfo = { _ in }
  public var onSelectionChange: MarkdownEditor.SelectionInfo = { _ in }
  public var onEditorHeightChange: MarkdownEditor.EditorHeight = { _ in }
  
  
  //  let parser: MarkdownParser
  
  /// Deliver `NSTextView.didChangeSelectionNotification` for all selection changes.
  ///
  /// See the documenation for `setSelectedRanges(_:affinity:stillSelecting:)` for details.
  public var continuousSelectionNotifications: Bool = false
  
  public init(
    frame frameRect: NSRect,
    textContainer container: NSTextContainer?,
    isShowingFrames: Bool,
    textInsets: CGFloat
  ) {
    
    self.isShowingFrames = isShowingFrames
    self.textInsets = textInsets
    
    //    self.parser = MarkdownParser()
    
    let container = NSTextContainer()
    
    let textLayoutManager = MarkdownLayoutManager()
    
    textLayoutManager.textContainer = container
    
    let textContentStorage = MarkdownContentStorage()
    
    textContentStorage.addTextLayoutManager(textLayoutManager)
    textContentStorage.primaryTextLayoutManager = textLayoutManager
    
    super.init(frame: frameRect, textContainer: container)
    
    self.textViewSetup()
    
    //    self.parser.text = self.string
    
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //
  //  func parseInlineCode() {
  //    guard let textContentManager = self.textLayoutManager?.textContentManager else { return }
  //
  //    inlineCodeElements.removeAll()
  //
  ////    let fullRange = NSRange(location: 0, length: string.utf16.count)
  //    let regex = Markdown.Syntax.inlineCode.regex
  //
  //    regex.
  //
  //    regex.enumerateMatches(in: string, options: [], range: fullRange) { match, _, _ in
  //      if let matchRange = match?.range {
  //        let element = InlineCodeElement(range: matchRange)
  //        inlineCodeElements.append(element)
  //
  //        textContentManager.performEditingTransaction {
  //          textContentManager.addTextElement(element, for: NSTextRange(matchRange, in: textContentManager))
  //        }
  //      }
  //    }
  //
  //    print("Found \(inlineCodeElements.count) inline code elements")
  //  }
  //
  //
  
  
  public override var layoutManager: NSLayoutManager? {
    assertionFailure("TextKit 1 is not supported by this type")
    return nil
  }
  
  
  //  public override var intrinsicContentSize: NSSize {
  //    textLayoutManager?.usageBoundsForTextContainer.size ?? .zero
  //  }
  //
  //  func assembleMetrics() {
  //    guard let documentRange = self.textLayoutManager?.documentRange else { return }
  //
  //    var textElementCount: Int = 0
  //
  //    textLayoutManager?.textContentManager?.enumerateTextElements(from: documentRange.location, using: { _ in
  //      textElementCount += 1
  //      return true
  //    })
  //
  ////    DispatchQueue.main.async {
  //      self.editorMetrics = """
  //      Editor height: \(self.intrinsicContentSize.height.description)
  //      Character count: \(self.string.count)
  //      Text elements: \(textElementCount.description)
  //      Document range: \(documentRange.description)
  //      """
  ////    }
  //    NotificationCenter.default.post(name: .metricsDidChange, object: self)
  //
  //  }
  
}

extension Notification.Name {
  static let metricsDidChange = Notification.Name("metricsDidChange")
}




extension MarkdownTextView {
  
  
  var editorHeight: CGFloat {
    
    guard let tlm = self.textLayoutManager
    else { return .zero }
    let documentRange = tlm.documentRange
    let typographicBounds: CGFloat = tlm.typographicBounds(in: documentRange)?.height ?? .zero
    let height = (textInsets * 2) + typographicBounds
    
    return height
  }
  
  func countCodeBlocks() {
    //    guard let self.textLayoutManager
    
    
  }
  
  private func setupViewportLayoutController() {
    guard let textLayoutManager = self.textLayoutManager else { return }
    
    viewportDelegate = CustomViewportDelegate()
    viewportDelegate?.textView = self
    
    viewportLayoutController = NSTextViewportLayoutController(textLayoutManager: textLayoutManager)
    viewportLayoutController?.delegate = viewportDelegate
    
    // Set the initial viewport
    //    viewportLayoutController?.viewportRange = self.visibleRange
  }
  
  //  private func updateViewport() {
  //    viewportLayoutController?.viewportRange = self.visibleRange
  //  }
  
  public override func scrollWheel(with event: NSEvent) {
    super.scrollWheel(with: event)
    //    updateViewport()
  }
  
  func testStyles() {
    
    guard let tlm = self.textLayoutManager,
          let tcm = tlm.textContentManager,
          let tcs = self.textContentStorage
            //          let visible = tlm.textViewportLayoutController.viewportRange
    else { return }
    
    let testAttrs: [NSAttributedString.Key: Any] = [
      .foregroundColor: NSColor.yellow
    ]
    
    let documentRange = tlm.documentRange
    
    let nsRange = NSRange(documentRange, in: tcm)
    
    //    guard let fullString = tcs.attributedString(in: documentRange)?.string else { return }
    
    tcm.performEditingTransaction {
      
      
      
      var ranges: [NSTextRange] = []
      
      for match in self.string.matches(of: Markdown.Syntax.inlineCode.regex) {
        
        // Convert String.Index to integer offset
        let startOffset = self.string.distance(from: self.string.startIndex, to: match.startIndex)
        let endOffset = self.string.distance(from: self.string.startIndex, to: match.endIndex)
        
        // Use these offsets to create NSTextLocation
        if let startLocation = tcm.location(documentRange.location, offsetBy: startOffset),
           let endLocation = tcm.location(documentRange.location, offsetBy: endOffset),
           let textRange = NSTextRange(location: startLocation, end: endLocation) {
          ranges.append(textRange)

        
//        
//        //        print(match)
//        
//        if let startIndex = tcm.offset(from: documentRange.location, to: match.startIndex),
//           let endIndex = tcm.offset(from: documentRange.location, to: match.endIndex),
//           let textRange = NSTextRange(location: startIndex, end: endIndex) {
//          ranges.append(textRange)
          //        }
        }
        
//        tcs.textStorage?.addAttributes(testAttrs, range: nsRange)
      }
      
      for range in ranges {
        
        tcs.textStorage?.setAttributes(testAttrs, range: nsRange)

        
      }
      
    }
  }
  
  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    self.onTextChange(calculateTextInfo())
    self.onEditorHeightChange(self.editorHeight)
    
    self.countCodeBlocks()
    
    setupViewportLayoutController()
    
    self.testStyles()
    
  }
  
  public override func layout() {
    super.layout()
    //    updateViewport()
  }
  
  
  
  public override func keyDown(with event: NSEvent) {
    onKeyDown(event) {
      super.keyDown(with: event)
    }
  }
  
  public override func flagsChanged(with event: NSEvent) {
    onFlagsChanged(event) {
      super.flagsChanged(with: event)
    }
  }
  
  public override func mouseDown(with event: NSEvent) {
    onMouseDown(event) {
      super.mouseDown(with: event)
    }
  }
  
  public override func draw(_ rect: NSRect) {
    super.draw(rect)
    
    if isShowingFrames {
      let border:NSBezierPath = NSBezierPath(rect: bounds)
      let borderColor = NSColor.red.withAlphaComponent(0.08)
      borderColor.set()
      border.lineWidth = 1.0
      border.fill()
    }
  }
}
