//
//  Annoying.swift
//  Phone Jail
//
//  Created by David Villegas on 12/20/22.
//

import Foundation
import AVFoundation
import UIKit

func MakePhoneAnnoying(view: UIView) {
    print("MakePhoneAnnoying")
    lightShow(view: view)
    playSoundIndefinitely()
}


private var timer: Timer?

private func lightShow(view: UIView) {
    let flashLight = AVCaptureDevice.default(for: AVMediaType.video)
    do {
        try flashLight?.lockForConfiguration()
    } catch {
        // handle the error
    }

    let redLight = UIView()
    redLight.backgroundColor = .red
    redLight.isHidden = false
    view.insertSubview(redLight, at: 0)
    redLight.frame = view.frame

    let blueLight = UIView()
    blueLight.backgroundColor = .blue
    blueLight.isHidden = true
    view.insertSubview(blueLight, at: 0)
    blueLight.frame = view.frame

    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
        // Check if the desired torch mode is supported by the device
            if flashLight?.isTorchModeSupported(.on) == true {
                // toggle the flashlight and the red and blue lights on and off at the same time
                flashLight?.torchMode = flashLight?.torchMode == .on ? .off : .on
            }
        
        redLight.isHidden.toggle()
        blueLight.isHidden.toggle()
    }
}

private func playSoundIndefinitely() {
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        var soundId: SystemSoundID = 1304
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, _) in
            AudioServicesPlaySystemSound(soundId)
        }, nil)
        AudioServicesPlaySystemSound(soundId)
    } catch {
        print(error)
    }
}


