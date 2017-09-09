//
//  Util.swift
//  PastePad
//
//  Copyright © 2017 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

enum TextMode:Int {
    case rich = 0
    case plain = 1
    
    var isRich:Bool {
        return self == .rich
    }
    
    var isPlain:Bool {
        return self == .plain
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
        return isRich ? .plain : .rich
    }
    
    func userFontOfSize(_ points:CGFloat) -> NSFont! {
        return isPlain ? NSFont.userFixedPitchFont(ofSize: points) : NSFont.userFont(ofSize: points)
    }
}

let RichType = kUTTypeRTF as String
let PlainType = kUTTypePlainText as String
let TextModeKey = "PPTextMode"
let TextModeDefault = TextMode.rich
let InspectorKey = "PPInspector"
let InspectorDefault = true
let RulerKey = "PPRuler"
let RulerDefault = false
let MaxPoints = 288.0

func fontToName(_ font: NSFont) -> String {
    return "\(font.pointSize)pt \(font.displayName!)"
}

func nameToFont(_ name: String, textMode: TextMode) -> NSFont {
    let scanner = Scanner(string:name)
    var points:Double = 0.0
    var face:NSString?
    
    scanner.scanDouble(&points)
    scanner.scanString("pt", into: nil);
    scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &face)
    
    if points > MaxPoints {
        points = MaxPoints
    }
    
    if let font = NSFont(name: face! as String, size: CGFloat(points)) {
        return font
    } else {
        return textMode.userFontOfSize(CGFloat(points))
    }
}
