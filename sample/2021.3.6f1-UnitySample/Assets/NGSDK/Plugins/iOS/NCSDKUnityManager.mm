// NAVER Game SDK for iOS
// Copyright 2021-present NAVER Corp.
//
// Unauthorized use, modification and redistribution of this software are strongly prohibited.
//
// Created by Alan on 2021/03/11.


// Naver Game SDK Bridge Code for Unity


#import <UIKit/UIKit.h>
#import "AppDelegateListener.h"
#import "UnityAppController.h"
#import <NNGSDK/NNGSDKManager.h>


typedef void (*NGSDKDidLoadDelegate)();
typedef void (*NGSDKDidUnloadDelegate)();
typedef void (*NGSDKDidReceiveInGameMenuCodeDelegate)(const char *inGameMenuCode);


@interface GLinkViewController : UIViewController <NNGSDKDelegate, AppDelegateListener>

@property (nonatomic, strong) UIViewController *mainViewcontroller;

@property (nonatomic, assign) NGSDKDidLoadDelegate ngSDKDidLoadDelegate;
@property (nonatomic, assign) NGSDKDidUnloadDelegate ngSDKDidUnloadDelegate;
@property (nonatomic, assign) NGSDKDidReceiveInGameMenuCodeDelegate ngSDKDidReceiveInGameMenuCodeDelegate;

@end


@implementation GLinkViewController

// The version of the SDK.
- (NSString *)getSdkVersion {
    return NNGSDKManager.shared.version;
}


// The ISO_3166-1 alpha-2 country code of each device.
- (NSString *)getCountryCode {
    return NNGSDKManager.shared.countryCode;
}


// Set the root view and the delegate for SDK.
- (void)setGLRootViewController {
    _mainViewcontroller = UnityGetGLViewController();
    [NNGSDKManager.shared setParentViewController:_mainViewcontroller];
    NNGSDKManager.shared.delegate = self;
}


// Set client ID, client secret, and lounge ID for SDK
- (void)setClientId:(NSString *)clientId clientSecret:(NSString *)cs loungeId:(NSString *)loungeId {
    [NNGSDKManager.shared setClientId:clientId clientSecret:cs loungeId:loungeId];
    UnityRegisterAppDelegateListener(self);
    [self setGLRootViewController];
}

- (void)onOpenURL:(NSNotification *)notification {
    NSURL *url = notification.userInfo[@"url"];
    [NNGSDKManager.shared handleCallbackUrl: url];
}

- (void)setCanWriteFeedByScreenshot:(BOOL)enabled {
    NNGSDKManager.shared.canWriteFeedByScreenshot = enabled;
}


- (void)setGameId:(NSString *)gameId {
    [NNGSDKManager.shared registerMemberGameId:gameId];
}


- (void)setAppName:(NSString *)appName {
    NNGSDKManager.shared.appName = appName;
}


- (void)setAppScheme:(NSString *)appScheme {
    NNGSDKManager.shared.appScheme = appScheme;
}


- (NSString *)getAuthSettingDescription {
    return NNGSDKManager.shared.authSettingDescription;
}


// Present the banner list.
- (void)executeHomeBanner {
    [self setGLRootViewController];
    [NNGSDKManager.shared presentBannerViewController];
}


// Present a notice while your game is not on service.
- (void)executeSorryBanner {
    [self setGLRootViewController];
    [NNGSDKManager.shared presentSorryViewController];
}


// Present the list of feeds identified by a predefined board ID which represents a board.
- (void)executeBoard:(int)boardId {
    [self setGLRootViewController];
    [NNGSDKManager.shared presentBoardViewControllerWith:@(boardId)];
}


// Present the feed identified by a feed ID.
- (void)executeFeed:(long)feedId isTempFeedId:(BOOL)isTempFeedId {
    [self setGLRootViewController];
    [NNGSDKManager.shared presentFeedViewControllerWith:@(feedId) scheduled:isTempFeedId];
}


- (void)executeFeedWriting:(int)boardId title:(NSString *)title text:(NSString *)text imageFilePath:(NSString *)imageFilePath {
    [self setGLRootViewController];
    [NNGSDKManager.shared presentFeedWritingWithBoardId:@(boardId) title:title text:text imageFilePath:imageFilePath];
}


// Dismiss all SDK-related views.
- (void)terminateSdk {
    [NNGSDKManager.shared dismiss];
}

- (void)naverLogout {
    [NNGSDKManager.shared logout];
}


#pragma mark NNGSDKDelegate

// Implementation for the delegate method -nngSDKDidLoad.
- (void)nngSDKDidLoad {
    if (self.ngSDKDidLoadDelegate) {
        self.ngSDKDidLoadDelegate();
    }
}


// Implementation for the delegate method -nngSDKDidUnload.
- (void)nngSDKDidUnload {
    if (self.ngSDKDidUnloadDelegate) {
        self.ngSDKDidUnloadDelegate();
    }
}


// Implementation for the delegate method -nngSDKDidReceiveInGameMenuCode:.
- (void)nngSDKDidReceiveInGameMenuCode:(NSString *)inGameMenuCode {
    if (self.ngSDKDidReceiveInGameMenuCodeDelegate) {
        self.ngSDKDidReceiveInGameMenuCodeDelegate(inGameMenuCode.UTF8String);
    }
}

@end


// Convert C strings to NSString objects
NSString* NNGSDKCreateNSString (const char* string) {
    if (string) {
        return [NSString stringWithUTF8String:string];
    } else {
        return [NSString stringWithUTF8String:""];
        [UIImage imageWithCGImage:nil];
    }
}


// C style interfaces for the upper codes.
extern "C" {

    char* NNGSDKCreateNSStringToChar (const char* string) {
        if (string == NULL)
            return NULL;
        char* res = (char*) malloc (strlen(string) + 1 );
        strcpy (res, string);
        return res;
    }

    GLinkViewController *vc = [[GLinkViewController alloc] init];

    void _InitGLink(const char* clientId, const char* clientSecret, const char* loungeId) {
        [vc setClientId:NNGSDKCreateNSString(clientId) clientSecret:NNGSDKCreateNSString(clientSecret) loungeId:NNGSDKCreateNSString(loungeId)];
    }

    const char* _GetSdkVersion() {
        return NNGSDKCreateNSStringToChar([vc getSdkVersion].UTF8String);
    }

    const char* _GetCountryCode() {
        return NNGSDKCreateNSStringToChar([vc getCountryCode].UTF8String);
    }

    void _SetCanWriteFeedByScreenshot(bool enabled) {
        [vc setCanWriteFeedByScreenshot:enabled];
    }

    void _SetGameId(const char* gameId) {
        [vc setGameId:NNGSDKCreateNSString(gameId)];
    }

    void _SetAppName(const char* appName) {
        [vc setAppName:NNGSDKCreateNSString(appName)];
    }

    void _SetAppScheme(const char* appScheme) {
        [vc setAppScheme:NNGSDKCreateNSString(appScheme)];
    }

    const char* _GetAuthSettingDescription() {
        return NNGSDKCreateNSStringToChar([vc getAuthSettingDescription].UTF8String);
    }

    void _ExecuteHomeBanner() {
        [vc executeHomeBanner];
    }

    void _ExecuteSorryBanner() {
        [vc executeSorryBanner];
    }

    void _ExecuteBoard(int boardId) {
        [vc executeBoard:boardId];
    }

    void _ExecuteFeed(long feedId, bool isTempFeedId) {
        [vc executeFeed:feedId isTempFeedId:isTempFeedId];
    }

    void _ExecuteFeedWriting(int boardId, const char* title, const char* text, const char* imageFilePath) {
        [vc executeFeedWriting:boardId title:NNGSDKCreateNSString(title) text:NNGSDKCreateNSString(text) imageFilePath:NNGSDKCreateNSString(imageFilePath)];
    }

    void _TerminateSdk() {
        [vc terminateSdk];
    }

    void _NaverLogout() {
        [vc naverLogout];
    }

    void _SetSDKDidLoadDelegate(NGSDKDidLoadDelegate ngSDKDidLoadDelegate) {
        vc.ngSDKDidLoadDelegate = ngSDKDidLoadDelegate;
    }

    void _SetSDKDidUnloadDelegate(NGSDKDidUnloadDelegate ngSDKDidUnloadDelegate) {
        vc.ngSDKDidUnloadDelegate = ngSDKDidUnloadDelegate;
    }

    void _SetSDKDidReceiveInGameMenuCodeDelegate(NGSDKDidReceiveInGameMenuCodeDelegate ngSDKDidReceiveInGameMenuCodeDelegate) {
        vc.ngSDKDidReceiveInGameMenuCodeDelegate = ngSDKDidReceiveInGameMenuCodeDelegate;
    }

}
