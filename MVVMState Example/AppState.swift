//
//  AppState.swift
//  MVVMState Example
//
//  Created by Ivan Foong Kwok Keong on 15/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import Foundation

enum AppState {
    case timerStarted(AppData)
    case timerPaused(AppData)
    case timerStopped(AppData)
}
