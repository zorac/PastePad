import AppKit

/**
 * Document class for PastePad.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2014-2019 Mark Rigby-Jones. All rights reserved.
 */
class Document : NSDocument, NSFontChanging {
    /// The standard user defaults.
    let defaults = UserDefaults.standard
    /// Text being loaded from a file.
    var loading: NSAttributedString?
    /// The current text mode.
    var textMode = TextMode.rich
    /// Whether the inspector is currently diplayed.
    var inspector = true
    /// Whether the ruler is currently displayed.
    var ruler = false
    /// The text view displaying this document.
    var textView: NSTextView!
    
    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
        
        let viewController = windowController.contentViewController as! ViewController;
        
        textView = viewController.textView;
        textView.enabledTextCheckingTypes = 0
        inspector = DefaultsKey.inspector.boolValue()
        ruler = DefaultsKey.ruler.boolValue()
        
        if let attributed = loading {
            if textMode == .rich {
                setTextMode(.rich)
            }
            
            textView.textStorage!.setAttributedString(attributed)
            
            if textMode == .plain {
                setTextMode(.plain)
            }
            
            loading = nil
        } else if let mode = TextMode(rawValue: DefaultsKey.textMode.intValue()) {
            setTextMode(mode);
        } else {
            setTextMode(.rich)
        }
        
        defaults.addObserver(self, forKeyPath: TextMode.plain.fontKey.rawValue, options: .new, context: nil)
    }
    
    override func canClose(withDelegate delegate: Any, shouldClose shouldCloseSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        if fileURL == nil {
            updateChangeCount(.changeCleared)
        }
        
        super.canClose(withDelegate: delegate, shouldClose: shouldCloseSelector, contextInfo: contextInfo)
    }
    
    override func writableTypes(for saveOperation: NSDocument.SaveOperationType) -> [String] {
        return [ textMode.fileType ]
    }
    
    /// Action to toggle between plain and rcih text modes.
    @IBAction func togglePlainText(_: AnyObject) {
        if (textMode.isRich) {
            inspector = textView.usesInspectorBar
            ruler = textView.isRulerVisible
        }
        
        setTextMode(textMode.other)
    }
    
    /// Action to toggle the inspector.
    @IBAction func toggleInspector(_: AnyObject) {
        inspector = !inspector
        
        if (textMode.isRich) {
            textView.usesInspectorBar = inspector
        }
    }
    
    /**
     * Set the text mode of this document.
     *
     * - Parameter: The new text mode.
     */
    func setTextMode(_ newTextMode: TextMode) {
        textMode = newTextMode
        
        let text = textView.textStorage!.string
        let rich = textMode.isRich
        let fontKey = textMode.fontKey
        let font = NSFont.fromName(fontKey.stringValue(), textMode: rich ? .rich : .plain)
        let attributes: [NSAttributedString.Key : Any] = [ .font: font ]
        let attributed = NSAttributedString(string: text, attributes: attributes)
        
        textView.isRichText = rich
        textView.textStorage!.setAttributedString(attributed)
        textView.typingAttributes = attributes
        textView.usesFontPanel = rich
        textView.usesInspectorBar = rich ? inspector : false
        textView.isRulerVisible = rich ? ruler : false
        
        if let url = fileURL {
            save(to: url, ofType: textMode.fileType, for: .autosaveInPlaceOperation, completionHandler: { error in
                if (error != nil) {
                    self.fileURL = nil
                }
            })
        }
        
        fileType = textMode.fileType
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (!textMode.isRich) {
            setTextMode(.plain)
        }
    }
    
    func validModesForFontPanel(_ fontPanel: NSFontPanel) -> NSFontPanel.ModeMask {
        return .allModes
    }
    
    override func data(ofType typeName: String) throws -> Data {
        if typeName == textMode.fileType {
            if let storage = textView.textStorage {
                return try storage.data(from: NSMakeRange(0, storage.length), documentAttributes: [.documentType: textMode.documentType])
            }
        }
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        switch typeName {
        case TextMode.plain.fileType:
            textMode = .plain
        case TextMode.rich.fileType:
            textMode = .rich
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        
        try loading = NSAttributedString(data: data, options: [.documentType: textMode.documentType], documentAttributes: nil)
    }
}
