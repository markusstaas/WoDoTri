//
//  stopWatch.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/11/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import QuartzCore

class StopWatch: NSObject {
    
    private var displayLink: CADisplayLink!
    private let formatter = DateFormatter()
    
    var callback: (() -> Void)?
    var elapsedTime: CFTimeInterval!
    var stopwatchStatus: String = "Stopped"
    
    override init() {
        super.init()
        self.displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
        displayLink.isPaused = true
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        self.elapsedTime = 0.0
        formatter.timeZone = TimeZone(abbreviation: "GMT")!
        formatter.dateFormat = "HH:mm:ss"
    }
    
    convenience init(withCallback callback: @escaping () -> Void) {
        self.init()
        self.callback = callback
    }
    deinit {
        displayLink.invalidate()
    }
    
    @objc func tick(sender: CADisplayLink) {
        elapsedTime = elapsedTime + displayLink.duration
        callback?()
    }
    
    func start() {
        displayLink.isPaused = false
    }
    
    func stop() {
        displayLink.isPaused = true
    }
    
    func paused(){
        displayLink.isPaused = true
        
    }
    
    func reset() {
        displayLink.isPaused = true
        elapsedTime = 0.0
        callback?()
    }
    
    func elapsedTimeAsString() -> String {
        return formatter.string(from: Date(timeIntervalSinceReferenceDate:elapsedTime))
    }

}
