//
//  ViewController.swift
//  ads-button
//
//  Created by Fritz Huie on 2/22/17.
//  Copyright © 2017 Fritz. All rights reserved.

import UIKit
import UnityAds

import AVKit

class ViewController: UIViewController, UnityAdsDelegate {

    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var gameIdTextField: UITextField!
    @IBOutlet weak var completedViewLabel: UILabel!
    @IBOutlet weak var gameIdLabel: UILabel!
    
    var gameId = "1016671"
    var placement = ""
    var initialized = false
    var completedViews = 0
    
    let green = UIColor.init(colorLiteralRed: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
    let red = UIColor.init(colorLiteralRed: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsButton.isEnabled = true
        adsButton.setTitle("Inititalize test ID", for: .normal)
        gameIdTextField.text = "(default)"
        }
    
    @IBAction func gameIdEntered(_ sender: Any) {
        gameIdTextField.resignFirstResponder()
        
        if(gameIdTextField.text == ""){
            gameId = "1016671";
            print("game ID set to \(gameId)")
            adsButton.setTitle("Inititalize test ID", for: .normal)
            gameIdTextField.text = "(default)"
            gameIdTextField.clearsOnBeginEditing = true
        }else{
            gameId = gameIdTextField.text!;
            adsButton.setTitle("Inititalize ID \"\(gameId)\"", for: .normal)
            print("game ID set to \(gameId)")
            gameIdTextField.clearsOnBeginEditing = false
        }
    }
    
    func updateAdsButton () {
        if(initialized) {
            updateButtonReadyState()
        }
    }

    @IBAction func showAd(_ sender: Any) {
        if(!initialized){
            UnityAds.initialize(gameId, delegate: self)
            initialized = true
            adsButton.isUserInteractionEnabled = false
            updateButtonReadyState()
            gameIdTextField.isHidden = true;
            gameIdTextField.resignFirstResponder()
            gameIdLabel.text = "Using Game ID \(gameId)"
            return
        }
        
        if(placement == ""){
            if(UnityAds.isReady()){
                UnityAds.show(self)
                print("Showing ad with default placement")
            }
        }else{
            if(UnityAds.isReady()){
                UnityAds.show(self, placementId: placement)
                print("Showing ad with placement ID: \(placement)")
            }
        }
        
    }
    
    func updateButtonReadyState(){
        if(placement == "" ? UnityAds.isReady() : UnityAds.isReady(placement)){
            adsButton.setTitle("Show Ad", for: .normal)
            adsButton.backgroundColor = green;
            adsButton.isUserInteractionEnabled = true
        }else{
            adsButton.setTitle("Loading ...", for: .normal)
            adsButton.backgroundColor = red;
            adsButton.isUserInteractionEnabled = false
        }
    }
    
    func unityAdsReady(_ placementId: String) {
        updateButtonReadyState()
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
