//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import GoogleMobileAds

public final class NSAdsService {
    
    public init() {}
    
    public func start(_ completionHandler: GADInitializationCompletionHandler?) {
        GADMobileAds.sharedInstance().start(completionHandler: completionHandler)
    }
}
