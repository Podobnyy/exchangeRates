//
//  BaseController.m
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "BaseController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@import GoogleMobileAds; // GOOGLE

@interface BaseController () <GADBannerViewDelegate, GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial; // GOOGLE
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView; // GOOGLE Банер
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView2; // GOOGLE Банер

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //GOOGLE
    //    [self reklamaInterstitialCreateAndDownload]; // создаем и загружаем
        [self firstBannerView];
}

#pragma mark - Google Banner Actions
- (void)firstBannerView{
    // GOOGLE Банер
    // ca-app-pub-2400450779974795/8877102928   -   Kurs_banner_base
    // ca-app-pub-2400450779974795/6199926558   -   Kurs_banner_iPad
    // ca-app-pub-3940256099942544/2934735716   -   Google TEST
    
    // создаем
    self.bannerView.adUnitID = @"ca-app-pub-2400450779974795/8877102928"; //ca-app-pub-2400450779974795/8877102928
    self.bannerView.rootViewController = self;
    // загружаем
    [self.bannerView loadRequest:[GADRequest request]];
    // становимся у себя делегатом
    self.bannerView.delegate = self;
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        self.bannerView2.adUnitID = @"ca-app-pub-2400450779974795/6199926558"; // +iPad
        //ca-app-pub-2400450779974795/6199926558
        self.bannerView2.rootViewController = self;
        // загружаем
        [self.bannerView2 loadRequest:[GADRequest request]];
        // становимся у себя делегатом
        self.bannerView2.delegate = self;
    }
}

- (void)restarBannerView{
    // загружаем
    [self.bannerView loadRequest:[GADRequest request]];
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        [self.bannerView2 loadRequest:[GADRequest request]];
    }
}

#pragma mark - Google Interstitial Actions
- (void)reklamaInterstitialCreateAndDownload{
    // создаем и загружаем
    // создаем
    // ca-app-pub-2400450779974795/6639211573 - На весь экрна
    // ca-app-pub-3940256099942544/4411468910   -   Google TEST
    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:@"ca-app-pub-2400450779974795/6639211573"];
    // загружаем
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
}

- (void)reklamaInterstitialShowing{ // показываем
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"реклама не загружена");
    }
}




#pragma mark - GADBannerViewDelegate
- (void) adViewDidReceiveAd: (GADBannerView *) adView {
    // обновлять Рекламу каждые 90 сек // -метод реклама загружена
    [self performSelector:@selector(restarBannerView) withObject:self afterDelay:90.0];
}




//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)pushBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
