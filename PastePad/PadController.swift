//
//  PadController.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

var counter = 0

class PadController: NSWindowController, NSWindowDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var textMode = TextModeDefault
    var inspector = InspectorDefault
    var ruler = RulerDefault
    
    @IBOutlet var scrollView : NSScrollView
    
    var textView:NSTextView {
        return scrollView.contentView.documentView as NSTextView
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        inspector = defaults.boolForKey(InspectorKey)
        ruler = defaults.boolForKey(RulerKey)
        
        if let mode = TextMode.fromRaw(defaults.integerForKey(TextModeKey)) {
            setTextMode(mode);
        } else {
            setTextMode(TextModeDefault)
        }

        defaults.addObserver(self, forKeyPath:TextMode.Plain.fontKey, options:.New, context:nil)
        self.window.title = String(format:"PastePad %ld", ++counter)
    }
    
    @IBAction func togglePlainText(AnyObject) {
        if (textMode.isRich) {
            inspector = textView.usesInspectorBar
            ruler = textView.rulerVisible
        }
        
        setTextMode(textMode.other)
    }
    
    @IBAction func toggleInspector(AnyObject) {
        inspector = !inspector

        if (textMode.isRich) {
            textView.usesInspectorBar = inspector
        }
    }

    func setTextMode(newTextMode:TextMode) {
        textMode = newTextMode

        let text = textView.textStorage.string
        let rich = textMode.isRich
        let fontKey = textMode.fontKey
        let font = nameToFont(defaults.stringForKey(fontKey), rich ? .Rich : .Plain)
        let attributes = [NSFontAttributeName:font]
        let attributed = NSAttributedString(string:text, attributes:attributes)
        
        textView.richText = rich
        textView.textStorage.setAttributedString(attributed)
        textView.typingAttributes = attributes
        textView.usesFontPanel = rich
        textView.usesInspectorBar = rich ? inspector : false
        textView.rulerVisible = rich ? ruler : false
    }
    
    override func observeValueForKeyPath(keyPath:String!, ofObject object:AnyObject!, change:[NSObject:AnyObject]!, context:UnsafePointer<()>) {
        if (!textMode.isRich) {
            setTextMode(.Plain)
        }
    }
    
    override func validModesForFontPanel(fontPanel:NSFontPanel!) -> Int {
        return Int(NSFontPanelAllModesMask)
    }
    
    func windowWillClose(notification:NSNotification!) {
        let appDelegate = NSApp.delegate as AppDelegate;
        
        appDelegate.windowWillClose(self)
    }
}
