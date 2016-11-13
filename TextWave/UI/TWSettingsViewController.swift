//
//  TWSettingsViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 5/12/16.
//  Copyright © 2016 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSettingsViewController: UIViewController {
    @IBOutlet var rateSlider:UISlider! = nil
    @IBOutlet var pitchSlider:UISlider! = nil
    
    override func viewDidLoad() {
        self.rateSlider.minimumValue = TWPlaybackConfiguration.defaultConfiguration.minRate
        self.rateSlider.maximumValue = TWPlaybackConfiguration.defaultConfiguration.maxRate
        self.pitchSlider.minimumValue = TWPlaybackConfiguration.defaultConfiguration.minPitch
        self.pitchSlider.maximumValue = TWPlaybackConfiguration.defaultConfiguration.maxPitch
    }
    
    @IBAction func onRateChange(_ sender:AnyObject?) {
        let newRate = self.rateSlider.value
        TWPlaybackConfiguration.defaultConfiguration.speechRate = newRate;
    }
    
    @IBAction func onPitchChange(_ sender:AnyObject?) {
        let newPitch = self.pitchSlider.value
        TWPlaybackConfiguration.defaultConfiguration.speechPitch = newPitch;
    }   
}
