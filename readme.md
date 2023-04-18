iOS Ads Cocos

Add Button in Cocos Creator Scene
Add Click event in Button 

onClickButtonInterstitial() {
   console.log("Interstitial BUTTON CLICKED");
   native.reflection.callStaticMethod(
     "AppDelegate",
     "callInterstitialNativeUIWithTitle:andContent:",
     "cocos2d-js",
     "Yes! you call a Native UI from Reflection"
   );
 }

Here native.reflection.callStaticMethod  function used for calling  method in iOS 

Native.reflection.callStaticMethod("Classname”,"FunctionName”,”Params”);

Where class name is AppDelegate,function which we used to call in appdelegate is callInterstitialsUIWithTitle
Which take both parameter as string

 callInterstitialsUIWithTitle function we make after ios build in      appdelegate 

Make ios Build
Add Pod file 
(Use this link for adding pod)
Import sdk 

pod 'Google-Mobile-Ads-SDK'



target 'iOSAdsOn-mobile' do
  # Comment the next line if you don't want to use dynamic frameworks
   use_frameworks!
   pod 'Google-Mobile-Ads-SDK'
  # Pods for iOSAdsOn-mobile
Here iOSAdsOn is Project name add we have to add sdk in that

Open workspace file
Add code snippet in Info.plist  info.plist code snippet 
In AppDelegate.m import @import GoogleMobileAds;
Declare Globle variable
    UIViewController *viewController;

And add  below code in function didFinishLaunchingWithOptions
      [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
//  set viewController object  to current view of appdelegate 
viewController=self.window.rootViewController;


For adding Interstial ads 

Import 
@import GoogleMobileAds;
@property(nonatomic, strong) GADInterstitialAd *interstitial;

In ViewController.mm

Add function for interstitial ads
For more info follow https://developers.google.com/admob/ios/interstitial
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
 
Then call this function from AppDelegate.mm
Belove function is native function call on cocos creator button clicked
+(void)callInterstitialNativeUIWithTitle:(NSString *) title andContent:(NSString* )content{
    NSLog(@"CALL FROM COCOS---------------------------------1");
    [viewController load];// call load function of viewconroller
    NSLog(@"CALL FROM COCOS---------------------------------2");
}

 


For Banner Ads above 10 point remain same

Add function in viewcontroller.mm

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
// for setting area where ads to show
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

Call viewcontroller function from Appdelegate

+(void)callBannerNativeUIWithTitle:(NSString *) title andContent:(NSString* )content{
    NSLog(@"CALL FROM COCOS---------------------------------1");
    [viewController banner];
    NSLog(@"CALL FROM COCOS---------------------------------2");
}



For Rewards Ads add function in viewcontroller
Import @property(nonatomic, strong) GADRewardedAd *rewardedAd;

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

Call viewcontroller function from Appdelegate
This function can call from cocos via native call
+(void)callRewardNativeUIWithTitle:(NSString *) title andContent:(NSString* )content{
    NSLog(@"CALL FROM COCOS---------------------------------1");
  //  [viewController load];
    [viewController loadRewardedAd];
    NSLog(@"CALL FROM COCOS---------------------------------2");
}


Issues you might face
Test the Ads on a device or you might receive an Error named “cannot find framework FBLPromises” if testing is done on Simulator.
Need to Update “Info.plist” and execute command “pod install --repo-update “every time we re-build Cocos Creator app.

