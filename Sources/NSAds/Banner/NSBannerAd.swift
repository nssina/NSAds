//
//  File.swift
//  
//
//  Created by Sina Rabiei on 1/22/23.
//

import SwiftUI
import GoogleMobileAds

public struct NSBannerAdView: View {
    @State var height: CGFloat = 0
    @State var width: CGFloat = 0
    @State var adPosition: NSAdPosition
    let adUnitId: String
    
    public init(adPosition: NSAdPosition, adUnitId: String) {
        self.adPosition = adPosition
        self.adUnitId = adUnitId
    }
    
    public enum NSAdPosition {
        case top
        case bottom
    }
    
    public var body: some View {
        VStack {
            if adPosition == .bottom {
                Spacer()
            }
            
            NSBannerAdRepresentable(adUnitId: adUnitId)
                .frame(width: width, height: height, alignment: .center)
                .onAppear {
                    setFrame()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    setFrame()
                }
            
            if adPosition == .top {
                Spacer()
            }
        }
    }
    
    private func setFrame() {
        let safeAreaInsets = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?
            .safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
}

private final class NSBannerAdViewController: UIViewController {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView()

    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        view.addSubview(bannerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBannerAd()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width

        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView.load(GADRequest())
    }
}

private struct NSBannerAdRepresentable: UIViewControllerRepresentable {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    func makeUIViewController(context: Context) -> NSBannerAdViewController {
        return NSBannerAdViewController(adUnitId: adUnitId)
    }

    func updateUIViewController(_ uiViewController: NSBannerAdViewController, context: Context) {}
}
