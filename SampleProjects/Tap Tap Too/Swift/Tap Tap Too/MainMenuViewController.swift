//  Converted to Swift 5 by Swiftify v5.0.39846 - https://swiftify.com/
//
//  MainMenuViewController.swift
//  Tap Tap Too
//
//  Created by Alejandro Zamudio Guajardo on 6/20/17.
//  Copyright © 2017 Adamant Jumper. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UIViewControllerProtocols {
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var matchesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.layer.borderWidth = 2.0
        playButton.layer.borderColor = UIColor.aqua()?.cgColor
        playButton.tintColor = UIColor.aqua()
        playButton.layer.cornerRadius = 8.0
        //matchesButton.layer.borderWidth = 2.0
        //matchesButton.layer.borderColor = UIColor.violet().cgColor
        //matchesButton.tintColor = UIColor.violet()
        //matchesButton.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismiss(animated flag: Bool) {
        navigationController?.popViewController(animated: true)
    }

// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Play Game") {
            let inGameViewController = segue.destination as? InGameViewController
            inGameViewController?.delegate = self
        } else {
        }
    }
}
