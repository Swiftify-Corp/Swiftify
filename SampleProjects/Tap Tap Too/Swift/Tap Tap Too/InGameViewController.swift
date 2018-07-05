//
//  InGameViewController.swift
//  Tap Tap Too
//
//  Created by Alejandro Zamudio Guajardo on 6/20/17.
//  Copyright © 2017 Adamant Jumper. All rights reserved.
//

import AVFoundation
import UIKit

class InGameViewController: UIViewController, AVAudioPlayerDelegate {
    weak var delegate: UIViewControllerProtocols?

    @IBOutlet private weak var firstPlayerButton: UIButton!
    @IBOutlet private weak var secondPlayerButton: UIButton!
    @IBOutlet private weak var firstPlayerNameLabel: UILabel!
    @IBOutlet private weak var secondPlayerNameLabel: UILabel!
    @IBOutlet private weak var firstPlayerTapsLabel: UILabel!
    @IBOutlet private weak var secondPlayerTapsLabel: UILabel!
    @IBOutlet private weak var firstPlayerTimerLabel: UILabel!
    @IBOutlet private weak var secondPlayerTimerLabel: UILabel!

    var firstPlayerTapCount: Int = 0
    var secondPlayerTapCount: Int = 0
    var totalGameTime: Int = 60
    var gameTimer: Timer?
    var shadowView: UIView?
    var nameRegisteringView: UIView?
    var registerLabel: UILabel?
    var nameInputTextField: UITextField?
    var continueButton: UIButton?
    var winnerDisplayingView: UIView?
    var gameWinnerLabel: UILabel?
    var gameResultLabel: UILabel?
    var hasFirstPlayerBeenRegistered = false
    var gameAudioPlayer: AVAudioPlayer?
    var soundsAudioPlayer: AVAudioPlayer?
    var gameMusic: URL?
    var gameEndedSound: URL?
    var winnerName = ""
    var winnerTaps: Int = 0
    var isItATie = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
        presentPlayerRegistrationView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadGameMusic() {
        defer {
        }
        do {
            gameMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "TimeGames", ofType: "wav") ?? "")
            if let aMusic = gameMusic {
                gameAudioPlayer = try? AVAudioPlayer(contentsOf: aMusic)
            }
        } catch let exception {
            print("Music couldn't be load")
        } 
        gameAudioPlayer?.enableRate = true
        gameAudioPlayer?.prepareToPlay()
        gameAudioPlayer?.play()
        gameAudioPlayer?.volume = 1.0
        gameAudioPlayer?.delegate = self
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        gameAudioPlayer?.play()
    }

    func configureUIElements() {
        firstPlayerNameLabel.transform = CGAffineTransform(rotationAngle: .pi)
        firstPlayerTapsLabel.transform = CGAffineTransform(rotationAngle: .pi)
        firstPlayerTimerLabel.transform = CGAffineTransform(rotationAngle: .pi)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func updateTotalGameTime() {
        if totalGameTime > 0 {
            if totalGameTime < 30 {
                gameAudioPlayer?.rate = 1.5
            }
            if totalGameTime < 15 {
                gameAudioPlayer?.rate = 2.0
            }
            totalGameTime = totalGameTime - 1
            firstPlayerTimerLabel.text = String(format: "%i", totalGameTime)
            secondPlayerTimerLabel.text = String(format: "%i", totalGameTime)
        } else {
            endGame()
        }
    }

    func startGame() {
        loadGameMusic()
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(InGameViewController.updateTotalGameTime), userInfo: nil, repeats: true)
    }

    func endGame() {
        gameTimer?.invalidate()
        gameAudioPlayer?.stop()
        defer {
        }
        do {
            gameEndedSound = URL(fileURLWithPath: Bundle.main.path(forResource: "buzzer_x", ofType: "wav") ?? "")
            if let aSound = gameEndedSound {
                soundsAudioPlayer = try? AVAudioPlayer(contentsOf: aSound)
            }
        } catch let exception {
            print("Music couldn't be load")
        } 
        soundsAudioPlayer?.prepareToPlay()
        soundsAudioPlayer?.play()
        soundsAudioPlayer?.volume = 1.0
        determineWinner()
        presentEndGameView()
    }

    func determineWinner() {
        if firstPlayerTapCount > secondPlayerTapCount {
            winnerName = firstPlayerNameLabel.text ?? ""
            winnerTaps = firstPlayerTapCount
        } else if firstPlayerTapCount < secondPlayerTapCount {
            winnerName = secondPlayerNameLabel.text ?? ""
            winnerTaps = secondPlayerTapCount
        } else {
            isItATie = true
            winnerTaps = firstPlayerTapCount
        }
    }

    func presentEndGameView() {
        var endGameText: String
        if isItATie {
            endGameText = "It is a tie!"
        } else {
            endGameText = "\("Winner: ")\(winnerName)"
        }
        let endGameTaps = "\("Taps: ")%i"
        var frame: CGRect = view.frame
        shadowView = UIView(frame: frame)
        shadowView?.backgroundColor = UIColor.shadow()
        frame = CGRect(x: view.frame.size.width / 8.0, y: view.frame.size.height / 4.0, width: view.frame.size.width / 1.3, height: view.frame.size.height / 3.0)
        winnerDisplayingView = UIView(frame: frame)
        winnerDisplayingView?.backgroundColor = UIColor.white
        winnerDisplayingView?.clipsToBounds = true
        winnerDisplayingView?.layer.cornerRadius = 8
        frame = CGRect(x: 0.0, y: (winnerDisplayingView?.frame.size.height ?? 0.0) / 8.0, width: winnerDisplayingView?.frame.size.width ?? 0.0, height: (winnerDisplayingView?.frame.size.height ?? 0.0) / 6.0)
        gameWinnerLabel = UILabel(frame: frame)
        gameWinnerLabel?.backgroundColor = UIColor.white
        if let aColor = UIColor.violet() {
            gameWinnerLabel?.textColor = aColor
        }
        gameWinnerLabel?.text = endGameText
        gameWinnerLabel?.textAlignment = .center
        if let aSize = UIFont(name: "HelveticaNeue", size: 25) {
            gameWinnerLabel?.font = aSize
        }
        frame = CGRect(x: 0.0, y: (winnerDisplayingView?.frame.size.height ?? 0.0) / 2.7, width: winnerDisplayingView?.frame.size.width ?? 0.0, height: (winnerDisplayingView?.frame.size.height ?? 0.0) / 6.0)
        gameResultLabel = UILabel(frame: frame)
        gameResultLabel?.backgroundColor = UIColor.white
        if let aColor = UIColor.violet() {
            gameResultLabel?.textColor = aColor
        }
        gameResultLabel?.text = endGameTaps
        gameResultLabel?.textAlignment = .center
        if let aSize = UIFont(name: "HelveticaNeue", size: 25) {
            gameResultLabel?.font = aSize
        }
        frame = CGRect(x: (winnerDisplayingView?.frame.size.width ?? 0.0) / 8.0, y: (winnerDisplayingView?.frame.size.height ?? 0.0) / 1.5, width: (winnerDisplayingView?.frame.size.width ?? 0.0) / 1.3, height: (winnerDisplayingView?.frame.size.height ?? 0.0) / 4.5)
        continueButton = UIButton(frame: frame)
        continueButton?.backgroundColor = UIColor.violet()
        continueButton?.clipsToBounds = true
        continueButton?.layer.cornerRadius = 8
        continueButton?.setTitle("Continue", for: .normal)
        continueButton?.setTitleColor(UIColor.white, for: .normal)
        continueButton?.contentVerticalAlignment = .center
        continueButton?.addTarget(self, action: #selector(InGameViewController.registerMatch), for: .touchUpInside)
        if let aView = shadowView {
            view.addSubview(aView)
        }
        if let aView = winnerDisplayingView {
            view.addSubview(aView)
        }
        if let aLabel = gameWinnerLabel {
            winnerDisplayingView?.addSubview(aLabel)
        }
        if let aLabel = gameResultLabel {
            winnerDisplayingView?.addSubview(aLabel)
        }
        if let aButton = continueButton {
            winnerDisplayingView?.addSubview(aButton)
        }
    }

    @objc func registerMatch() {
        delegate?.dismiss(animated: true)
    }

    func presentPlayerRegistrationView() {
        var frame: CGRect = view.frame
        shadowView = UIView(frame: frame)
        shadowView?.backgroundColor = UIColor.shadow()
        frame = CGRect(x: view.frame.size.width / 8.0, y: view.frame.size.height / 4.0, width: view.frame.size.width / 1.3, height: view.frame.size.height / 3.0)
        nameRegisteringView = UIView(frame: frame)
        nameRegisteringView?.backgroundColor = UIColor.white
        nameRegisteringView?.clipsToBounds = true
        nameRegisteringView?.layer.cornerRadius = 8
        frame = CGRect(x: 0.0, y: (nameRegisteringView?.frame.size.height ?? 0.0) / 8.0, width: nameRegisteringView?.frame.size.width ?? 0.0, height: (nameRegisteringView?.frame.size.height ?? 0.0) / 6.0)
        registerLabel = UILabel(frame: frame)
        registerLabel?.backgroundColor = UIColor.white
        if let aColor = UIColor.violet() {
            registerLabel?.textColor = aColor
        }
        registerLabel?.text = "Enter player's name"
        registerLabel?.textAlignment = .center
        if let aSize = UIFont(name: "HelveticaNeue", size: 25) {
            registerLabel?.font = aSize
        }
        frame = CGRect(x: (nameRegisteringView?.frame.size.width ?? 0.0) / 8.0, y: (nameRegisteringView?.frame.size.height ?? 0.0) / 2.3, width: (nameRegisteringView?.frame.size.width ?? 0.0) / 1.3, height: (nameRegisteringView?.frame.size.height ?? 0.0) / 5.5)
        nameInputTextField = UITextField(frame: frame)
        nameInputTextField?.borderStyle = .roundedRect
        nameInputTextField?.layer.borderColor = UIColor.black.cgColor
        nameInputTextField?.contentVerticalAlignment = .center
        nameInputTextField?.textAlignment = .left
        nameInputTextField?.keyboardType = .alphabet
        nameInputTextField?.keyboardAppearance = .light
        nameInputTextField?.clearButtonMode = .whileEditing
        if let aColor = UIColor.violet() {
            nameInputTextField?.tintColor = aColor
        }
        nameInputTextField?.textColor = UIColor.violet()
        nameInputTextField?.font = UIFont(name: "HelveticaNeue", size: 15)
        if hasFirstPlayerBeenRegistered {
            nameInputTextField?.placeholder = "Second player's name"
        } else {
            nameInputTextField?.placeholder = "First player's name"
        }
        frame = CGRect(x: (nameRegisteringView?.frame.size.width ?? 0.0) / 8.0, y: (nameRegisteringView?.frame.size.height ?? 0.0) / 1.5, width: (nameRegisteringView?.frame.size.width ?? 0.0) / 1.3, height: (nameRegisteringView?.frame.size.height ?? 0.0) / 4.5)
        continueButton = UIButton(frame: frame)
        continueButton?.backgroundColor = UIColor.violet()
        continueButton?.clipsToBounds = true
        continueButton?.layer.cornerRadius = 8
        if !hasFirstPlayerBeenRegistered {
            continueButton?.setTitle("Continue", for: .normal)
        } else {
            continueButton?.setTitle("Start", for: .normal)
        }
        continueButton?.setTitleColor(UIColor.white, for: .normal)
        continueButton?.contentVerticalAlignment = .center
        continueButton?.addTarget(self, action: #selector(InGameViewController.registerPlayerName), for: .touchUpInside)
        if let aView = shadowView {
            view.addSubview(aView)
        }
        if let aView = nameRegisteringView {
            view.addSubview(aView)
        }
        if let aLabel = registerLabel {
            nameRegisteringView?.addSubview(aLabel)
        }
        if let aField = nameInputTextField {
            nameRegisteringView?.addSubview(aField)
        }
        if let aButton = continueButton {
            nameRegisteringView?.addSubview(aButton)
        }
    }

    func hidePlayerRegistrationView() {
        registerLabel?.removeFromSuperview()
        nameInputTextField?.removeFromSuperview()
        continueButton?.removeFromSuperview()
        nameRegisteringView?.removeFromSuperview()
        if hasFirstPlayerBeenRegistered {
            shadowView?.removeFromSuperview()
        }
    }

    @objc func registerPlayerName() {
        if !(nameInputTextField?.text == "") {
            if !hasFirstPlayerBeenRegistered {
                firstPlayerNameLabel.text = nameInputTextField?.text
                hasFirstPlayerBeenRegistered = true
                hidePlayerRegistrationView()
                presentPlayerRegistrationView()
            } else {
                secondPlayerNameLabel.text = nameInputTextField?.text
                hidePlayerRegistrationView()
                startGame()
            }
        }
    }

    @IBAction func tap(_ sender: UIButton) {
        if sender == firstPlayerButton {
            firstPlayerTapCount = firstPlayerTapCount + 1
            firstPlayerTapsLabel.text = String(format: "%i", firstPlayerTapCount)
        } else {
            secondPlayerTapCount = secondPlayerTapCount + 1
            secondPlayerTapsLabel.text = String(format: "%i", secondPlayerTapCount)
        }
    }
}