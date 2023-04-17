/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 Copyright (c) 2013-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2022 Xiamen Yaji Software Co., Ltd.

 http://www.cocos.com

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated engine source code (the "Software"), a limited,
 worldwide, royalty-free, non-assignable, revocable and non-exclusive license
 to use Cocos Creator solely to develop games on your target platforms. You shall
 not use Cocos Creator software for developing other software or tools that's
 used for developing games. You are not granted to publish, distribute,
 sublicense, and/or sell copies of Cocos Creator.

 The software or tools in this License Agreement are licensed, not sold.
 Xiamen Yaji Software Co., Ltd. reserves all rights not expressly granted to you.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
****************************************************************************/

#import "ViewController.h"
#import "AppDelegate.h"
#import "platform/ios/AppDelegateBridge.h"
//#include "cocos/platform/Device.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

namespace {
//    cc::Device::Orientation _lastOrientation;
}

@interface ViewController ()<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitialAd *interstitial;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@end

@implementation ViewController






-(void)load{
    NSLog(@"ADD LOAD FUNCTION CALL ");

  GADRequest *request = [GADRequest request];
    NSLog(@"REQUEST GAD %@",request);
  [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"
                              request:request
                    completionHandler:^(GADInterstitialAd *ad, NSError *error) {
    if (error) {
      NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
      return;
    }
      NSLog(@"no error");
    self.interstitial = ad;
    
   
      
      if (self.interstitial) {
          NSLog(@"before call");
         
          ViewController *rootController =(ViewController*)[[(AppDelegate*)
                                             [[UIApplication sharedApplication]delegate] window] rootViewController];
        [self.interstitial presentFromRootViewController:self];
          NSLog(@"after call");
      } else {
        NSLog(@"Ad wasn't ready");
      }
     
  }];
    

}
-(void)banner{
    NSLog(@" IN BANNER FUNCTION");
    // In this case, we instantiate the banner with desired ad size.
      self.bannerView = [[GADBannerView alloc]
          initWithAdSize:GADAdSizeBanner];

      [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
      self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}
- (void)addBannerViewToView:(UIView *)bannerView {
    NSLog(@" IN BANNER VIEW MAKE FUNCTION");
  bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:bannerView];
  [self.view addConstraints:@[
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view.safeAreaLayoutGuide
                               attribute:NSLayoutAttributeBottom
                              multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                               attribute:NSLayoutAttributeCenterX
                              multiplier:1
                                constant:0]
                                ]];
}

- (void)loadRewardedAd {
    NSLog(@" IN REWARD FUNCTION");
  GADRequest *request = [GADRequest request];
  [GADRewardedAd
       loadWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"
                request:request
      completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
          return;
        }
        self.rewardedAd = ad;
        NSLog(@"Rewarded ad loaded.");
      }];
    [self.rewardedAd presentFromRootViewController:self
                                     userDidEarnRewardHandler:^{
                                     GADAdReward *reward =
                                         self.rewardedAd.adReward;
                                     // TODO: Reward the user!
                                   }];
}
- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Controls the application's preferred home indicator auto-hiding when this view controller is shown.
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
   AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
   [delegate.appDelegateBridge viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
   float pixelRatio = [delegate.appDelegateBridge getPixelRatio];

   //CAMetalLayer is available on ios8.0, ios-simulator13.0.
   CAMetalLayer *layer = (CAMetalLayer *)self.view.layer;
   CGSize tsize             = CGSizeMake(static_cast<int>(size.width * pixelRatio),
                                         static_cast<int>(size.height * pixelRatio));
   layer.drawableSize = tsize;
}

@end
