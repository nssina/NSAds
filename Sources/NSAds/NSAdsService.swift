//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import GoogleMobileAds

final class NSAdsService {
    func start(_ completionHandler: @escaping GADInitializationCompletionHandler) {
        GADMobileAds.sharedInstance().start(completionHandler: completionHandler)
    }
}
