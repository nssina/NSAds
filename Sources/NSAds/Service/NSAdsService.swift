//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import GoogleMobileAds

public final class NSAdsService {
    let shared = NSAdsService()
    
    public func start(_ completionHandler: @escaping GADInitializationCompletionHandler) {
        GADMobileAds.sharedInstance().start(completionHandler: completionHandler)
    }
}
