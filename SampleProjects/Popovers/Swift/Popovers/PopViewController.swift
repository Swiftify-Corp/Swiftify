//
//  PopViewController.swift
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
            // add touch recogniser to dismiss this controller
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopViewController.dismissMe))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissMe() {
        print("Popover was dismissed with internal tap")
        dismiss(animated: true)
    }
}