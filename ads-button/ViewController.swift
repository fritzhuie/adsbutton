//
//  ViewController.swift
//  ads-button
//
//  Created by Fritz Huie on 2/22/17.
//  Copyright © 2017 Fritz. All rights reserved.

import UIKit
import UnityAds

class ViewController: UIViewController, UnityAdsDelegate {

    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var gameIdTextField: UITextField!
    @IBOutlet weak var completedViewLabel: UILabel!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var testModeToggle: UISwitch!
    @IBOutlet weak var testModeLabel: UILabel!
    
    var gameId:String = "1016671"
    var placement:String = ""
    var initialized:Bool = false
    var completedViews:Int = 0
    var allowRotation:Bool = true
    
    let green = UIColor.init(colorLiteralRed: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
    let red = UIColor.init(colorLiteralRed: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsButton.isEnabled = true
        adsButton.setTitle("Inititalize test ID", for: .normal)
        gameIdTextField.text = "\(gameId)"
        
        completedViewLabel.isHidden = true
    }
    
    override var shouldAutorotate: Bool {
        return allowRotation
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    @IBAction func gameIdEntered(_ sender: Any) {
        return
    }
    
    func updateStatusText() {
        switch UnityAds.getPlacementState() {
        case .disabled:
            gameIdLabel.text = "Unity Ads not enabled"
        case .noFill:
            gameIdLabel.text = "Server returned no fill"
        case .notAvailable:
            gameIdLabel.text = "Unity Ads not available"
        case .ready:
            gameIdLabel.text = "Unity Ads is ready"
        case .waiting:
            gameIdLabel.text = "Waiting . . ."
        default:
            gameIdLabel.text = "Status error"
        }
    }

    @IBAction func showAd(_ sender: Any) {
        if(!initialized){
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateStatusText), userInfo: nil, repeats: true)
            
            testModeToggle.isHidden = true
            testModeLabel.text = testModeToggle.isOn ? "Test mode: Enabled" : "Test mode: Disabled"
            allowRotation = false
            
            if(gameIdTextField.text == ""){
                gameIdTextField.clearsOnBeginEditing = true
            }else{
                gameId = gameIdTextField.text!;
                print("game ID set to \(gameId)")
            }
            
            if(testModeToggle.isOn){
                UnityAds.initialize(gameId, delegate: self, testMode: true)
            }else{
                UnityAds.initialize(gameId, delegate: self, testMode: false)
            }
            
            initialized = true
            adsButton.isUserInteractionEnabled = false
            
            updateButtonReadyState()
            
            gameIdTextField.isHidden = true;
            gameIdTextField.resignFirstResponder()
            gameIdLabel.text = "Inititalizing with \(gameId)"
            
            return
            
        }else{
            if(UnityAds.isReady()){
                if(placement == ""){
                    UnityAds.show(self)
                    print("Showing ad with default placement")
                }else{
                    UnityAds.show(self, placementId: placement)
                    print("Showing ad with placement ID: \(placement)")
                }
            }
        }
    }
    
    func updateButtonReadyState(){
        if(placement == "" ? UnityAds.isReady() : UnityAds.isReady(placement)){
            adsButton.setTitle("Show Ad", for: .normal)
            adsButton.backgroundColor = green;
            adsButton.isUserInteractionEnabled = true
        }else{
            adsButton.setTitle("Inititalizing \(gameId)", for: .normal)
            adsButton.backgroundColor = red;
            adsButton.isUserInteractionEnabled = false
        }
    }
    
    func unityAdsReady(_ placementId: String) {
        updateButtonReadyState()
        completedViewLabel.isHidden = false
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {

    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        if(state != .skipped){
            completedViews+=1
            completedViewLabel.text = "Completed Views: \(completedViews)"
        }
    }
    
    func unityAdsDidStart(_ placementId: String) {
        
    }
}
