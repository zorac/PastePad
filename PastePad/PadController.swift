//
//  PadController.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class PadController: NSDocument {
    let defaults = UserDefaults.standard
    
    var loading: NSAttributedString?
    var textMode = TextModeDefault
    var inspector = InspectorDefault
    var ruler = RulerDefault
    
    @IBOutlet var textView: NSTextView!
    
    override var windowNibName: String? {
        return "Pad"
    }
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        textView.enabledTextCheckingTypes = 0
        inspector = defaults.bool(forKey: InspectorKey)
        ruler = defaults.bool(forKey: RulerKey)
        
        if let attributed = loading {
            if textMode == .rich {
                setTextMode(.rich)
            }
            
            textView.textStorage!.setAttributedString(attributed)
            
            if textMode == .plain {
                setTextMode(.plain)
            }
            
            loading = nil
        } else if let mode = TextMode(rawValue:defaults.integer(forKey: TextModeKey)) {
            setTextMode(mode);
        } else {
            setTextMode(TextModeDefault)
        }

        defaults.addObserver(self, forKeyPath: TextMode.plain.fontKey, options: .new, context: nil)
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func canClose(withDelegate delegate: Any, shouldClose shouldCloseSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        if fileURL == nil {
            updateChangeCount(NSDocumentChangeType.changeCleared)
        }
        
        super.canClose(withDelegate: delegate, shouldClose: shouldCloseSelector, contextInfo: contextInfo)
    }

    
    override func writableTypes(for saveOperation: NSSaveOperationType) -> [String] {
        return [ textMode.fileType ]
    }
    
    @IBAction func togglePlainText(_: AnyObject) {
        if (textMode.isRich) {
            inspector = textView.usesInspectorBar
            ruler = textView.isRulerVisible
        }
        
        setTextMode(textMode.other)
    }
    
    @IBAction func toggleInspector(_: AnyObject) {
        inspector = !inspector

        if (textMode.isRich) {
            textView.usesInspectorBar = inspector
        }
    }

    func setTextMode(_ newTextMode: TextMode) {
        textMode = newTextMode

        let text = textView.textStorage!.string
        let rich = textMode.isRich
        let fontKey = textMode.fontKey
        let font = nameToFont(defaults.string(forKey: fontKey)!, textMode: rich ? .rich : .plain)
        let attributes = [ NSFontAttributeName: font ]
        let attributed = NSAttributedString(string: text, attributes: attributes)
        
        textView.isRichText = rich
        textView.textStorage!.setAttributedString(attributed)
        textView.typingAttributes = attributes
        textView.usesFontPanel = rich
        textView.usesInspectorBar = rich ? inspector : false
        textView.isRulerVisible = rich ? ruler : false
        
        if let url = fileURL {
            save(to: url, ofType: textMode.fileType, for: NSSaveOperationType.autosaveInPlaceOperation, completionHandler: { error in
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
    
    // TODO is this correct now?
    override func validModesForFontPanel(_ fontPanel: NSFontPanel) -> Int {
        return Int(NSFontPanelAllModesMask)
    }
    
    // TODO is this correct now?
    func windowWillClose(_ notification: Notification) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        
        appDelegate.windowWillClose(self)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        if typeName == textMode.fileType {
            if let storage = textView.textStorage {
                return try storage.data(from: NSMakeRange(0, storage.length), documentAttributes: [NSDocumentTypeDocumentAttribute: textMode.documentType])
            }
        }

        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        switch typeName {
        case PlainType:
            textMode = .plain
        case RichType:
            textMode = .rich
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }

        try loading = NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: textMode.documentType], documentAttributes: nil)
    }
}
