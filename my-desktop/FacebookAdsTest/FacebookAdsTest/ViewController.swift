//
//  ViewController.swift
//  FacebookAdsTest
//
//  Created by Jackson  on 17/06/2022.
//

import UIKit
import FBAudienceNetwork

class ViewController: UIViewController, FBAdViewDelegate {
    
    @IBOutlet weak var adContentView: UIView!
    
    private var adView: FBAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Instantiate an AdView object.
        // NOTE: the placement ID will eventually identify this as your app, you can ignore while you
        // are testing and replace it later when you have signed up.
        // While you are using this temporary code you will only get test ads and if you release
        // your code like this to the App Store your users will not receive ads (you will get a 'No Fill' error).
//        let ad = FBNativeAd(placementID: "2851846798450645_2851847155117276")
//        ad.regista
        
//        FBAdSettings.bidderToken
        let adView = FBAdView(placementID: "2851846798450645_2851847155117276", adSize: .init(size: CGSize(width: 320, height: 250)), rootViewController: self)
        adView.center = adContentView.center
        adView.delegate = self
        adView.loadAd(withBidPayload: "test_ property")
        self.adView = adView
        
    }

    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func adViewDidLoad(_ adView: FBAdView) {
        print("success")
    }
}

