//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import SwiftUI
import GoogleMobileAds

private final class NSInterstitialAdView: NSObject, GADFullScreenContentDelegate {
    
    let interstitialAd = NSInterstitialAdViewModel.shared.interstitialAd
    @Binding var isPresented: Bool
    var adUnitId: String
    
    init(isPresented: Binding<Bool>, adUnitId: String) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        super.init()
        
        interstitialAd?.fullScreenContentDelegate = self
    }
    
    func showAd(from root: UIViewController) {
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root)
        } else {
            print("Ad not ready")
            self.isPresented.toggle()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        NSInterstitialAdViewModel.shared.loadAd(withAdUnitId: adUnitId)
        
        isPresented.toggle()
    }
}

private struct NSInterstitialAdRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var adUnitId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = UIViewController()
        let adView = NSInterstitialAdView(isPresented: $isPresented, adUnitId: adUnitId)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            adView.showAd(from: view)
        }
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private struct NSInterstitialModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    @State var adType: AdType
    
    enum AdType {
        case interstitial
    }
    
    var rewardFunc: () -> Void
    var adUnitId: String
  
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
                EmptyView()
                    .edgesIgnoringSafeArea(.all)
                
                if adType == .interstitial {
                    NSInterstitialAdRepresentable(isPresented: $isPresented, adUnitId: adUnitId)
                }
            }
        }
        .onAppear {
            if adType == .interstitial {
                NSInterstitialAdViewModel.shared.loadAd(withAdUnitId: adUnitId)
            }
        }
    }
}

public extension View {
    func presentNSInterstitialAd(isPresented: Binding<Bool>, adUnitId: String) -> some View {
        NSInterstitialModifier(isPresented: isPresented, adType: .interstitial, rewardFunc: {}, adUnitId: adUnitId, parent: self)
    }
}
