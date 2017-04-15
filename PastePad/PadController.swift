//
//  PadController.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class PadController: NSDocument {
    let defaults = NSUserDefaults.standardUserDefaults()
    
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
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        textView.enabledTextCheckingTypes = 0
        inspector = defaults.boolForKey(InspectorKey)
        ruler = defaults.boolForKey(RulerKey)
        
        if let attributed = loading {
            setTextMode(textMode)
            textView.textStorage!.setAttributedString(attributed)
            loading = nil
        } else if let mode = TextMode(rawValue:defaults.integerForKey(TextModeKey)) {
            setTextMode(mode);
        } else {
            setTextMode(TextModeDefault)
        }

        defaults.addObserver(self, forKeyPath: TextMode.Plain.fontKey, options: .New, context: nil)
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func writableTypesForSaveOperation(saveOperation: NSSaveOperationType) -> [String] {
        return [ textMode.fileType ]
    }
    
    @IBAction func togglePlainText(_: AnyObject) {
        if (textMode.isRich) {
            inspector = textView.usesInspectorBar
            ruler = textView.rulerVisible
        }
        
        setTextMode(textMode.other)
    }
    
    @IBAction func toggleInspector(_: AnyObject) {
        inspector = !inspector

        if (textMode.isRich) {
            textView.usesInspectorBar = inspector
        }
    }

    func setTextMode(newTextMode: TextMode) {
        textMode = newTextMode

        let text = textView.textStorage!.string
        let rich = textMode.isRich
        let fontKey = textMode.fontKey
        let font = nameToFont(defaults.stringForKey(fontKey)!, textMode: rich ? .Rich : .Plain)
        let attributes = [ NSFontAttributeName: font ]
        let attributed = NSAttributedString(string: text, attributes: attributes)
        
        textView.richText = rich
        textView.textStorage!.setAttributedString(attributed)
        textView.typingAttributes = attributes
        textView.usesFontPanel = rich
        textView.usesInspectorBar = rich ? inspector : false
        textView.rulerVisible = rich ? ruler : false
        
        if let url = fileURL {
            saveToURL(url, ofType: textMode.fileType, forSaveOperation: NSSaveOperationType.AutosaveInPlaceOperation, completionHandler: { error in
                if (error != nil) {
                    self.fileURL = nil
                }
            })
        }
        
        fileType = textMode.fileType
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (!textMode.isRich) {
            setTextMode(.Plain)
        }
    }
    
    // TODO is this correct now?
    override func validModesForFontPanel(fontPanel: NSFontPanel) -> Int {
        return Int(NSFontPanelAllModesMask)
    }
    
    // TODO is this correct now?
    func windowWillClose(notification: NSNotification) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.windowWillClose(self)
    }
    
    override func dataOfType(typeName: String) throws -> NSData {
        if typeName == textMode.fileType {
            if let storage = textView.textStorage {
                return try storage.dataFromRange(NSMakeRange(0, storage.length), documentAttributes: [NSDocumentTypeDocumentAttribute: textMode.documentType])
            }
        }

        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func readFromData(data: NSData, ofType typeName: String) throws {
        switch typeName {
        case PlainType:
            textMode = .Plain
        case RichType:
            textMode = .Rich
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }

        try loading = NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: textMode.documentType], documentAttributes: nil)
    }
}
