//
//  BackupVerifyViewController.swift
//  Blockchain
//
//  Created by Sjors Provoost on 19-05-15.
//  Copyright (c) 2015 Qkos Services Ltd. All rights reserved.
//

import UIKit

class BackupVerifyViewController: UIViewController, UITextFieldDelegate {
    
    var wallet : Wallet?
    
    @IBOutlet weak var word1: UITextField?
    @IBOutlet weak var word2: UITextField?
    @IBOutlet weak var word3: UITextField?
    
    @IBOutlet weak var wrongWord: UILabel?
    
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        word1?.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        word2?.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        word3?.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        verifyButton.clipsToBounds = true
        verifyButton.layer.cornerRadius = Constants.Measurements.BackupButtonCornerRadius
    }
    
    @IBAction func done(sender: UIButton) {
        checkWords()
    }
    
    func checkWords() {
        var valid = true
        
        let words = wallet!.recoveryPhrase.componentsSeparatedByString(" ")
        
        if word1!.text.isEmpty || word2!.text.isEmpty || word3!.text.isEmpty {
            valid = false
        } else { // Don't mark words as invalid until the user has entered all three
            if word1!.text != words[0] {
                wrongWord?.hidden = false
                valid = false
            }
            if word2!.text != words[2] {
                wrongWord?.hidden = false
                valid = false
            }
            if word3!.text != words[5] {
                wrongWord?.hidden = false
                valid = false
            }
        }
        
        if valid {
            wallet!.markRecoveryPhraseVerified()
            NSNotificationCenter.defaultCenter().postNotificationName("AppDelegateReload", object: nil)
            self.performSegueWithIdentifier("unwindVerifyWords", sender: self)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        wrongWord?.hidden = true
        return true
    }
    
    func textFieldDidChange() {
        if !word1!.text.isEmpty && !word2!.text.isEmpty && !word3!.text.isEmpty {
            verifyButton.backgroundColor = Constants.Colors.BlockchainBlue
            verifyButton.enabled = true
            verifyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else if word1!.text.isEmpty || word2!.text.isEmpty || word3!.text.isEmpty {
            verifyButton.backgroundColor = Constants.Colors.SecondaryGray
            verifyButton.enabled = false
            verifyButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        checkWords()
        return true
    }

}
