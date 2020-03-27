//
//  AudioEffectCreator.swift
//  Dune
//
//  Created by Waylan Sands on 24/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import AVFoundation

class AudioEffectCreator {
    
    let engine = AVAudioEngine()
    var speedControl = AVAudioUnitVarispeed()
    var pitchControl = AVAudioUnitTimePitch()
    var eqControl = AVAudioUnitEQ()
    var reverbControl = AVAudioUnitReverb()
    var delayControl = AVAudioUnitDelay()
    let audioPlayer = AVAudioPlayerNode()
    var currentTime: TimeInterval?
    var effectURL: URL!
    
    func loadDefaultPresets() {
        speedControl.rate = 1 // 0.95 : 1.1
        pitchControl.pitch = 0 // -50 : 60
        eqControl.globalGain = 0 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 1500
        reverbControl.wetDryMix = 0
        
        audioPlayer.pan = 0
    }
    
    func loadMiamiPreset() {
        speedControl.rate = 1.05 // 0.95 : 1.1
        pitchControl.pitch = 30 // -50 : 60
        eqControl.globalGain = 3 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 1500
        reverbControl.wetDryMix = 2
        
        audioPlayer.pan = 0.3
    }
    
    func loadHostPreset() {
        speedControl.rate = 0.97 // 0.95 : 1.1
        pitchControl.pitch = -5 // -50 : 60
        eqControl.globalGain = 1 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 1500
        reverbControl.wetDryMix = 4
        
        audioPlayer.pan = -0.3
    }
    
    func loadNorwayPreset() {
        speedControl.rate = 1 // 0.95 : 1.1
        pitchControl.pitch = -20 // -50 : 60
        eqControl.globalGain = -2 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 700
        reverbControl.wetDryMix = 2
        
        audioPlayer.pan = -0.4
    }
    
    func loadFrankPresets() {
        if #available(iOS 13.0, *) {
            audioPlayer.sourceMode = .ambienceBed
        } else {
            // Fallback on earlier versions
        }
        audioPlayer.obstruction = -20
    }
    
    func loadNASAPreset() {
        speedControl.rate = 0.98 // 0.95 : 1.1
        pitchControl.pitch = -30 // -50 : 60
        eqControl.globalGain = 1 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 700
        reverbControl.wetDryMix = 7
        
        if #available(iOS 13.0, *) {
            audioPlayer.sourceMode = .bypass
        } else {
            // Fallback on earlier versions
        }
    }
    
    func loadButterPreset() {
        speedControl.rate = 0.95 // 0.95 : 1.1
        pitchControl.pitch = 40 // -50 : 60
        eqControl.globalGain = -2 // -5 : 5
        
        delayControl.delayTime = 0
        delayControl.lowPassCutoff = 1900
        reverbControl.wetDryMix = 1
    }
    
    func loadLiquidPreset() {
        
        if #available(iOS 13.0, *) {
            audioPlayer.sourceMode = .spatializeIfMono
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func play(url: URL , startTime: Double) throws {
        
        let file = try AVAudioFile(forReading: url)
        let totalFrameCount = file.length
        let audioFormat = file.processingFormat
        let audioRate = Float(audioFormat.sampleRate)
        let time = Float(startTime)
        
        let startFrame = floor(time * audioRate)
        let frameCount = Float(totalFrameCount) - startFrame
        var result: AVAudioEngineManualRenderingStatus

        
        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(speedControl)
        engine.attach(pitchControl)
        engine.attach(eqControl)
        engine.attach(delayControl)
        engine.attach(reverbControl)
        
        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: eqControl, format: nil)
        engine.connect(eqControl, to: reverbControl, format: nil)
        engine.connect(reverbControl, to: delayControl, format: nil)
        engine.connect(delayControl, to: engine.mainMixerNode, format: nil)
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
//        if startTime == 0 {
//
//        audioPlayer.scheduleFile(file, at: nil)
//
//        // 6: start the engine and play
//        try engine.start()
//        audioPlayer.play()
//        } else {
//
//            let startFrame = floor(time * sampleRateSong)
//            let frameCount = Float(songLengthSamples) - startFrame
//                print("Start Frame: \(startFrame)")
//                print("Start song Length Samples: \(songLengthSamples)")
//
//            let start = AVAudioTime(sampleTime: AVAudioFramePosition(startFrame), atRate: Double(sampleRateSong))
//
//            try engine.start()
//            engine.prepare()
//            audioPlayer.scheduleSegment(file, startingFrame: AVAudioFramePosition(startFrame), frameCount: AVAudioFrameCount(frameCount), at: start, completionHandler: nil)
//            audioPlayer.play(at: start)
//        }
        
        let effectsURL = FileManager.getDocumentsDirectory().appendingPathComponent("record-effects.m4a")
        

        let outfile = try! AVAudioFile(forWriting: effectsURL, settings: file.fileFormat.settings)
        audioPlayer.installTap(onBus: 0, bufferSize: AVAudioFrameCount(totalFrameCount), format: nil) {
          (buffer : AVAudioPCMBuffer!, time: AVAudioTime!) in
              do {
                try outfile.write(from: buffer)
              } catch {
                  print("Failed because of \(error)")
              }
          }
        
        try engine.start()
        audioPlayer.play()


    }
    

    
}

extension AVAudioPlayerNode{
    
    var current: TimeInterval{
        if let nodeTime = lastRenderTime,let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
}

