//
//  ViewController.swift
//  UITags
//
//  Created by Tsif on 12/07/2015.
//  Copyright (c) 2015 Tsif. All rights reserved.
//

import UIKit
import UITags

class ViewController: UIViewController, UITagsViewDelegate {

    @IBOutlet weak var tags: UITags!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tags.delegate = self
        self.tags.tags = ["These", "are", "some", "tags","These", "are", "some", "tags","These", "are", "some", "tags","These", "are", "some", "tags","These", "are", "some", "tags"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tagSelected(atIndex index:Int) -> Void {
        print("Tag at index:\(index) selected")
    }
    
    func tagDeselected(atIndex index:Int) -> Void {
        print("Tag at index:\(index) deselected")
    }

}

