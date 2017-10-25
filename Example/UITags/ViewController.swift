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
        self.tags.tags = ["These", "are", "some", "tags","Please", "specify", "an", "outlet","and", "also", "set", "the","delegate", "if", "you", "want","to", "be", "tappable"]
        
//        let delayTime = DispatchTime.now()
//        dispatch_after(dispatch_time_t(), Int64(2 * Double(NSEC_PER_SEC))) {
            self.tags.tags = ["These", "are", "some", "tags","Please", "specify", "an", "outlet","and", "also", "set", "the","delegate", "if", "you", "want","to", "be", "tappable", "more ","tags", "to", "show", "intrinstinct","size"]
//        }
        
        self.tags.setCustomColor(color: .cyan, selectedColor: .brown, position: 2)
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

