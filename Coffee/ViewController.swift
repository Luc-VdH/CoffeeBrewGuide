//
//  ViewController.swift
//  Coffee
//
//  Created by Luc Van Den Handel on 2019/06/04.
//  Copyright © 2019 Luc Van Den Handel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var start = true
    var timeKeep = 0
    var timer = Timer()
    var step = 0
    var grams = 15.0
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var duration = Float(30.0)
    var value = Float(1.0)
    
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var upNext: UILabel!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var startbutton: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var gramsLabel: UILabel!
    @IBOutlet weak var instructionImage: UIImageView!
    @IBOutlet weak var voiceOnOff: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let circularProgress = CircleProgress(frame: CGRect(x: 87.67, y: 408, width: 200.0, height: 200.0))
        circularProgress.progressColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        circularProgress.trackColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 0.6)
        circularProgress.tag = 101
        circularProgress.center = self.view.center
        self.view.addSubview(circularProgress)
        
        //animate progress
        
    }
    
    @objc func animateProgress() {
        let cp = self.view.viewWithTag(101) as! CircleProgress
        cp.setProgressWithAnimation(duration: TimeInterval(duration), value: value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func coffeeSlider(_ sender: UISlider) {
        //gain the desired weight of coffee from the user
        if timeKeep == 0{
            grams = round(Double(sender.value))
            gramsLabel.text = "\(Int(grams))g Coffee"
            upNext.text = "Next: Bloom \(Int(grams*2))g water"
        }else{
            sender.value = Float(grams)
        }
        
    }
    
    @IBAction func startpausetapped(_ sender: UIButton) {
        
        if start == true{
            //if timer is not running, starts the timer and changes the start button to a pause button
            
            instructionImage.image = UIImage(named: "pour")
            startbutton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
            start = false
        }else{
            //if the timer is running, halts the timer and changes the pause button back to the start button
            startbutton.setImage(UIImage(named: "start"), for: UIControl.State.normal)
            timer.invalidate()
            start = true
        }
        
        
    }
    
    @objc func action(){
        let water = grams*17.0
        if timeKeep == 0 && step == 0 && voiceOnOff.isOn{
            //plays the instructions for the first pour
            duration = Float(30.0)
           // self.perform(#selector(animateProgress), with: nil, afterDelay: 0.0)
            let myUtterance1 = AVSpeechUtterance(string: "Start Bloom Pour of \(Int(grams*2)) grams of water")
            myUtterance1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            myUtterance1.rate = 0.5
            synth.speak(myUtterance1)
        }
        if timeKeep == 30 && step == 0 && voiceOnOff.isOn{
            //plays the instructions for the second pour
            duration = Float(135.0)
           // self.perform(#selector(animateProgress), with: nil, afterDelay: 0.0)
            let myUtterance2 = AVSpeechUtterance(string: "Start Pour of \(Int(round(water/10)*10) - 10) grams of water")
            myUtterance2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            myUtterance2.rate = 0.5
            synth.speak(myUtterance2)
        }
        if timeKeep == 135{
            //if the time has finished, plays last message and resets app
            start = true
            startbutton.setImage(UIImage(named: "start"), for: UIControl.State.normal)
            timer.invalidate()
            step = 0
            timeKeep = 0
            time.text = String(timeKeep) + "s"
            instruction.text = "Enjoy your Coffee :)"
            upNext.text = "Next: Bloom \(Int(grams*2))g water"
            instructionImage.image = UIImage(named: "mug")
            if voiceOnOff.isOn{
                myUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
                myUtterance = AVSpeechUtterance(string: "Enjoy your Coffee")
                myUtterance.rate = 0.5
                synth.speak(myUtterance)
            }
            
        } else {
            if timeKeep < 30 && step < 1 {
                //displays the first 30s of the bloom pour along with the bloom pour message
                instruction.text = "Bloom \(Int(grams*2))g water"
                upNext.text = "Next: Pour \(Int(round(water/10)*10) - 10)g water"
                timeKeep += 1
                time.text = String(timeKeep) + "s"
                
            }else if step == 1{
                //displays last 135s and the message for the amount of water to pour
                instruction.text = "Pour \(Int(round(water/10)*10) - 10)g water"
                upNext.text = "Next: Enjoy your Coffee"
                timeKeep += 1
                time.text = String(timeKeep) + "s"
            }else{
                //resets the timer after 30s
                step += 1
                timeKeep = 0
                time.text = String(timeKeep) + "s"
                
                
            }
        }
        

    }
}

