//
//  ViewController.swift
//  MVVMState Example
//
//  Created by Ivan Foong Kwok Keong on 15/9/17.
//  Copyright © 2017 ivanfoong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var viewModel = ViewModel(state: .timerStopped(AppData(secondsRemaining: 100, initialSecondsRemaining: 100))) {
        didSet {
            switch self.viewModel.state {
            case .timerStarted(_):
                CountdownTimer.sharedInstace.start()
            default:
                CountdownTimer.sharedInstace.stop()
            }
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CountdownTimer.sharedInstace.handler = { [weak self] in
            self?.handleTick()
        }
        self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(textField:)), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(textFieldDidEndEditing(textField:)), for: .editingDidEndOnExit)
        self.updateUI()
    }
    
    deinit {
        CountdownTimer.sharedInstace.handler = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        self.viewModel = self.viewModel.buttonTapped()
    }
    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        if let text = textField.text, let initialSecondsRemaining = Int(text) {
            self.viewModel = self.viewModel.reset(with: initialSecondsRemaining)
        } else {
            self.viewModel = self.viewModel.reset(with: 0)
        }
    }
    
    @objc func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text, let initialSecondsRemaining = Int(text) {
            self.viewModel = self.viewModel.reset(with: initialSecondsRemaining)
        }
    }
    
    private func updateUI() {
        self.textField.text = self.viewModel.textFieldText
        self.button.setTitle(self.viewModel.buttonText, for: .normal)
    }
    
    private func handleTick() {
        self.viewModel = self.viewModel.tick()
    }
}

