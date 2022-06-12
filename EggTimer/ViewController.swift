//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimes = ["Soft": 10, "Medium": 420, "Hard": 720]
    var startingSeconds: Int = 0
    var remainingSeconds: Int = 0
    var progressedSeconds: Int = 0
    var player: AVAudioPlayer?


    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    @IBAction func hardnessSelected(_ sender: UIButton) {
        startingSeconds = eggTimes[sender.currentTitle!]!
        remainingSeconds = startingSeconds

        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        progressBar.progress = 0.0
    }
    
    @objc func update() {
        progressedSeconds = startingSeconds-remainingSeconds
        progressBar.progress = Float(progressedSeconds)/Float(startingSeconds)
        
        if progressedSeconds < startingSeconds {
            titleLabel.text = "\(remainingSeconds) seconds remaining."
            remainingSeconds -= 1
        } else {
            timer.invalidate()
            titleLabel.text = "Egg is ready!"
            playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
