//
//  ViewModel.swift
//  MVVMState Example
//
//  Created by Ivan Foong Kwok Keong on 15/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import Foundation

struct ViewModel {
    let state: AppState
    let textFieldText: String
    let buttonText: String
    
    init(state: AppState) {
        self.state = state
        
        switch self.state {
        case .timerStarted(let data):
            self.textFieldText = String(data.secondsRemaining)
            self.buttonText = "Pause"
        case .timerPaused(let data):
            self.textFieldText = String(data.secondsRemaining)
            self.buttonText = "Resume"
        case .timerStopped(let data):
            self.textFieldText = String(data.initialSecondsRemaining)
            self.buttonText = "Start"
        }
    }
    
    func buttonTapped() -> ViewModel {
        switch self.state {
        case .timerStarted(let data):
            return ViewModel(state: .timerPaused(data))
        case .timerPaused(let data):
            return ViewModel(state: .timerStarted(data))
        case .timerStopped(let data):
            let initialAppData = AppData(secondsRemaining: data.initialSecondsRemaining, initialSecondsRemaining: data.initialSecondsRemaining)
            return ViewModel(state: .timerStarted(initialAppData))
        }
    }
    
    func tick() -> ViewModel {
        switch self.state {
        case .timerStarted(let data):
            let currentSecondsRemaining = data.secondsRemaining - 1
            let newAppData = AppData(secondsRemaining: data.secondsRemaining - 1, initialSecondsRemaining: data.initialSecondsRemaining)
            if currentSecondsRemaining > 0 {
                return ViewModel(state: .timerStarted(newAppData))
            } else {
                return ViewModel(state: .timerStopped(newAppData))
            }
        default:
            return self
        }
    }
    func reset(with newInitialSecondsRemaining: Int) -> ViewModel {
        let newAppData = AppData(secondsRemaining: newInitialSecondsRemaining, initialSecondsRemaining: newInitialSecondsRemaining)
        return ViewModel(state: .timerStopped(newAppData))
    }
}
