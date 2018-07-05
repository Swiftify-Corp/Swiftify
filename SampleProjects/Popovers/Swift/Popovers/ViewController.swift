//
//  ViewController.swift
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet private var leftButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func barButtonLeft(_ sender: Any) {
            // grab the view controller we want to show
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UIViewController? = storyboard.instantiateViewController(withIdentifier: "Pop")
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller?.modalPresentationStyle = .popover
        if let aController = controller {
            present(aController, animated: true)
        }
            // configure the Popover presentation controller
        let popController: UIPopoverPresentationController? = controller?.popoverPresentationController
        popController?.permittedArrowDirections = .any
        popController?.barButtonItem = leftButton
        popController?.delegate = self
    }

    @IBAction func barButtonRight(_ sender: Any) {
            // grab the view controller we want to show
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UIViewController? = storyboard.instantiateViewController(withIdentifier: "Pop")
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller?.modalPresentationStyle = .popover
        if let aController = controller {
            present(aController, animated: true)
        }
            // configure the Popover presentation controller
        let popController: UIPopoverPresentationController? = controller?.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        // in case we don't have a bar button as reference
        popController?.sourceView = view
        popController?.sourceRect = CGRect(x: 30, y: 50, width: 10, height: 10)
    }

// MARK: - Popover Presentation Controller Delegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        // called when a Popover is dismissed
        print("Popover was dismissed with external tap. Have a nice day!")
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        // return YES if the Popover should be dismissed
        // return NO if the Popover should not be dismissed
        return true
    }

    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        // called when the Popover changes positon
    }
}