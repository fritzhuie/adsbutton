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
    
    var gameId:String = "1016671"
    var placement:String = ""
    var initialized:Bool = false
    var completedViews:Int = 0
    
    let green = UIColor.init(colorLiteralRed: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
    let red = UIColor.init(colorLiteralRed: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsButton.isEnabled = true
        adsButton.setTitle("Inititalize test ID", for: .normal)
        gameIdTextField.text = "(default)"
        }
    
    @IBAction func gameIdEntered(_ sender: Any) {
        return
    }
    
    func updateAdsButton () {
        if(initialized) {
            updateButtonReadyState()
        }
    }

    @IBAction func showAd(_ sender: Any) {
        if(!initialized){
            if(gameIdTextField.text == ""){
                gameIdTextField.clearsOnBeginEditing = true
            }else{
                gameId = gameIdTextField.text!;
                print("game ID set to \(gameId)")
            }
            
            UnityAds.initialize(gameId, delegate: self)
            initialized = true
            adsButton.isUserInteractionEnabled = false
            
            updateButtonReadyState()
            
            gameIdTextField.isHidden = true;
            gameIdTextField.resignFirstResponder()
            gameIdLabel.text = "Using Game ID \(gameId)"
            
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
            adsButton.setTitle("Loading ...", for: .normal)
            adsButton.backgroundColor = red;
            adsButton.isUserInteractionEnabled = false
        }
    }
    
    func unityAdsReady(_ placementId: String) {
        updateButtonReadyState()
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print("error 88888888888")
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
