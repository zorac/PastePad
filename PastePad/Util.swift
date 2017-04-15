//
//  Util.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

enum TextMode:Int {
    case Rich = 0
    case Plain = 1
    
    var isRich:Bool {
        return self == .Rich
    }
    
    var isPlain:Bool {
        return self == .Plain
    }
    
    var fileExtension:String {
        return isRich ? "rtf" : "txt"
    }
    
    var fileType:String {
        return isRich ? RichType : PlainType
    }
    
    var documentType:String {
        return isRich ? NSRTFTextDocumentType : NSPlainTextDocumentType
    }
    
    var fontKey:String {
        return isRich ? "PPRichFont" : "PPPlainFont"
    }
    
    var other:TextMode {
        return isRich ? .Plain : .Rich
    }
    
    func userFontOfSize(points:CGFloat) -> NSFont! {
        return isPlain ? NSFont.userFixedPitchFontOfSize(points) : NSFont.userFontOfSize(points)
    }
}

let RichType = kUTTypeRTF as String
let PlainType = kUTTypePlainText as String
let TextModeKey = "PPTextMode"
let TextModeDefault = TextMode.Rich
let InspectorKey = "PPInspector"
let InspectorDefault = true
let RulerKey = "PPRuler"
let RulerDefault = false
let MaxPoints = 288.0

func fontToName(font: NSFont) -> String {
    return "\(font.pointSize)pt \(font.displayName!)"
}

func nameToFont(name: String, textMode: TextMode) -> NSFont {
    let scanner = NSScanner(string:name)
    var points:Double = 0.0
    var face:NSString?

    scanner.scanDouble(&points)
    scanner.scanString("pt", intoString: nil);
    scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &face)
    
    if points > MaxPoints {
        points = MaxPoints
    }
        
    if let font = NSFont(name: face! as String, size: CGFloat(points)) {
        return font
    } else {
        return textMode.userFontOfSize(CGFloat(points))
    }
}
