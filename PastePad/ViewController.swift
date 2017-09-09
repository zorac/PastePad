//
//  ViewController.swift
//  PastePad
//
//  Copyright © 2017 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
