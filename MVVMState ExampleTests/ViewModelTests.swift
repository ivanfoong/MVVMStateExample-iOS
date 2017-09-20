//
//  ViewModelTests.swift
//  MVVMState ExampleTests
//
//  Created by Ivan Foong Kwok Keong on 20/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import XCTest
@testable import MVVMState_Example

class ViewModelTests: XCTestCase {
    
    var appData: AppData!
    var viewModels: [ViewModel]!
    
    override func setUp() {
        super.setUp()
        
        appData = AppData(secondsRemaining: 9, initialSecondsRemaining: 10)
        viewModels = [
            ViewModel(state: AppState.timerStopped(appData)),
            ViewModel(state: AppState.timerPaused(appData)),
            ViewModel(state: AppState.timerStarted(appData))
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        for viewModel in viewModels {
            switch viewModel.state {
            case .timerPaused(let appData):
                XCTAssertEqual(String(appData.secondsRemaining), viewModel.textFieldText)
                XCTAssertEqual("Resume", viewModel.buttonText)
            case .timerStarted(let appData):
                XCTAssertEqual(String(appData.secondsRemaining), viewModel.textFieldText)
                XCTAssertEqual("Pause", viewModel.buttonText)
            case .timerStopped(let appData):
                XCTAssertEqual(String(appData.initialSecondsRemaining), viewModel.textFieldText)
                XCTAssertEqual("Start", viewModel.buttonText)
            }
        }
    }
    
    func testButtonTapped() {
        for viewModel in viewModels {
            let newViewModel = viewModel.buttonTapped()
            
            switch viewModel.state {
            case .timerPaused(let appData):
                switch newViewModel.state {
                case .timerStarted(let newAppData):
                    XCTAssertEqual(appData, newAppData)
                default:
                    XCTFail()
                }
            case .timerStarted(let appData):
                switch newViewModel.state {
                case .timerPaused(let newAppData):
                    XCTAssertEqual(appData, newAppData)
                default:
                    XCTFail()
                }
            case .timerStopped(let appData):
                switch newViewModel.state {
                case .timerStarted(let newAppData):
                    XCTAssertEqual(appData.initialSecondsRemaining, newAppData.initialSecondsRemaining)
                    XCTAssertEqual(appData.initialSecondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func testTick() {
        for viewModel in viewModels {
            let newViewModel = viewModel.tick()
            
            switch viewModel.state {
            case .timerStarted(let appData):
                switch newViewModel.state {
                case .timerStarted(let newAppData):
                    XCTAssertEqual(appData.secondsRemaining-1, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            case .timerPaused(let appData):
                switch newViewModel.state {
                case .timerPaused(let newAppData):
                    XCTAssertEqual(appData.secondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            case .timerStopped(let appData):
                switch newViewModel.state {
                case .timerStopped(let newAppData):
                    XCTAssertEqual(appData.secondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            }
        }
        
        let endingViewModel = ViewModel(state: AppState.timerStarted(AppData(secondsRemaining: 1, initialSecondsRemaining: 10)))
        let endedViewModel = endingViewModel.tick()
        switch endedViewModel.state {
        case .timerStopped(let appData):
            XCTAssertEqual(0, appData.secondsRemaining)
            XCTAssertEqual(10, appData.initialSecondsRemaining)
        default:
            XCTFail()
        }
    }
    
    func testResetWithNewInitialSecondsRemaining() {
        let newInitialSecondsRemaining = 100
        for viewModel in viewModels {
            let newViewModel = viewModel.reset(with: newInitialSecondsRemaining)
            
            switch viewModel.state {
            case .timerStarted(_):
                switch newViewModel.state {
                case .timerStopped(let newAppData):
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.initialSecondsRemaining)
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            case .timerPaused(_):
                switch newViewModel.state {
                case .timerStopped(let newAppData):
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.initialSecondsRemaining)
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            case .timerStopped(_):
                switch newViewModel.state {
                case .timerStopped(let newAppData):
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.initialSecondsRemaining)
                    XCTAssertEqual(newInitialSecondsRemaining, newAppData.secondsRemaining)
                default:
                    XCTFail()
                }
            }
        }
    }
    
}
