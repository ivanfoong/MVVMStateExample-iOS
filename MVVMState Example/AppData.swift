//
//  AppData.swift
//  MVVMState Example
//
//  Created by Ivan Foong Kwok Keong on 15/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import Foundation

struct AppData: Equatable {
    let secondsRemaining: Int
    let initialSecondsRemaining: Int
}

func ==(lhs: AppData, rhs: AppData) -> Bool {
    return lhs.initialSecondsRemaining == rhs.initialSecondsRemaining &&
        lhs.secondsRemaining == rhs.secondsRemaining
}
