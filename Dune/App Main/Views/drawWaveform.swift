//
//  Draw2dWaveform.swift
//  Beatmaker
//
//  Created by Miguel Saldana on 10/17/16.
//  Copyright © 2016 Miguel Saldana. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
import AVFoundation

class StaticAudioWave: UIView {
        
    lazy var width = self.frame.width
    
    var timeInSeconds: Double = 0
    
    var aPath = UIBezierPath()
    var aPath2 = UIBezierPath()

    var topColor: UIColor
    var bottomColor: UIColor
    
    var amplitudeHeight: CGFloat = 400
    
    required init(color: UIColor, height: CGFloat) {
        self.topColor = color
        self.bottomColor = color
        self.amplitudeHeight = height
        super.init(frame: .zero)
        self.contentMode = .redraw
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.convertToPoints()
        var f = 0
        
        aPath.lineJoinStyle = .round
        aPath2.lineJoinStyle = .round
        
        aPath.lineWidth = 8.0
        aPath2.lineWidth = 8.0
        
        aPath.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height ))
        
        
        for _ in readFile.points{
                //separation of points
            var x:CGFloat = 10
                aPath.move(to: CGPoint(x:aPath.currentPoint.x + x , y:aPath.currentPoint.y ))
                
                //Y is the amplitude
                aPath.addLine(to: CGPoint(x:aPath.currentPoint.x  , y:aPath.currentPoint.y - (readFile.points[f] * amplitudeHeight) - 1.0))
                
                aPath.close()
                
                x += 1
                f += 1
        }
        

       
        //If you want to stroke it with a Orange color
        topColor.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        
        f = 0
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        
        //Reflection of waveform
        for _ in readFile.points {
            var x:CGFloat = 10
            aPath2.move(to: CGPoint(x:aPath2.currentPoint.x + x , y:aPath2.currentPoint.y ))
            
            //Y is the amplitude
            aPath2.addLine(to: CGPoint(x:aPath2.currentPoint.x  , y:aPath2.currentPoint.y - ((-1.0 * readFile.points[f]) * amplitudeHeight)))
            
            // aPath.close()
            aPath2.close()
            
            x += 1
            f += 1
        }
        
        //If you want to stroke it with a Orange color with alpha2
        bottomColor.set()
        aPath2.stroke(with: CGBlendMode.normal, alpha: 0.5)
        //   aPath.stroke()
        
        //If you want to fill it as well
        aPath2.fill()
    }
    
    func readArray( array:[Float]) {
        readFile.arrayFloatValues = array
    }
    
    func convertToPoints() {
        var processingBuffer = [Float](repeating: 0.0,
                                       count: Int(readFile.arrayFloatValues.count))
        let sampleCount = vDSP_Length(readFile.arrayFloatValues.count)

        vDSP_vabs(readFile.arrayFloatValues, 1, &processingBuffer, 1, sampleCount);
    
        var multiplier = 1.0
        if multiplier < 1{
            multiplier = 1.0
        }
        
        if timeInSeconds > 0 {
        let units = 340 * timeInSeconds
                
        let samplesPerPixel = Int(units * multiplier)
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                             count: Int(samplesPerPixel))
        let downSampledLength = Int(readFile.arrayFloatValues.count / samplesPerPixel)
        var downSampledData = [Float](repeating:0.0,
                                      count:downSampledLength)
        vDSP_desamp(processingBuffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
                
        //convert [Float] to [CGFloat] array
        readFile.points = downSampledData.map{CGFloat($0)}
        }
    }

    
    func reDrawBars(url : URL, color: UIColor, height: CGFloat) {
        self.topColor = color
        self.bottomColor = color
        self.amplitudeHeight = height
        
             let file = try! AVAudioFile(forReading: url)
                   guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false) else { return }
                   let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))
                   try! file.read(into: buf!)
                   
                   readFile.arrayFloatValues = Array(UnsafeBufferPointer(start: buf?.floatChannelData?[0], count:Int(buf!.frameLength)))
    }
}

struct readFile {
    static var arrayFloatValues:[Float] = []
    static var points:[CGFloat] = []
    
}
