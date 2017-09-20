//
//  CountdownTimer.swift
//  MVVMState Example
//
//  Created by Ivan Foong Kwok Keong on 19/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import Foundation

class CountdownTimer {
    static let sharedInstace = CountdownTimer()
    
    var timer: Timer?
    var handler: (()->Void)?
    
    private init() {
    }
    
    func start() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.handler?()
            }
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
