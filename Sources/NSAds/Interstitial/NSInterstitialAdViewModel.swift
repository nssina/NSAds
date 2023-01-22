//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import GoogleMobileAds

final class NSInterstitialAdViewModel: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    static let shared = NSInterstitialAdViewModel()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            
            self.interstitialAd = interstitialAd
        }
    }
}
