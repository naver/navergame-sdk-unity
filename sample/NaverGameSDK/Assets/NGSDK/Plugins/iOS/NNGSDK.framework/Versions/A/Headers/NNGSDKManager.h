// NAVER Game SDK for iOS
// Copyright 2021-present NAVER Corp.
//
// Unauthorized use, modification and redistribution of this software are strongly prohibited.
//
// Created by Alan on 2021/02/25.


#import <Foundation/Foundation.h>


@protocol NNGSDKDelegate;
@class UIViewController;


@interface NNGSDKManager : NSObject

// The singleton instance of SDK manager.
@property (class, nonatomic, readonly) NNGSDKManager *shared;

// Your client ID.
@property (strong, nonatomic, readonly) NSString *clientId;

// Your client Secret.
@property (strong, nonatomic, readonly) NSString *clientSecret;

// Your lounge ID.
@property (strong, nonatomic, readonly) NSString *loungeId;

// The ISO_3166-1 alpha-2 country code of each device.
@property (strong, nonatomic, readonly) NSString *countryCode;

// The version of the SDK.
@property (strong, nonatomic, readonly) NSString *version;

// Your App Scheme.
@property (strong, nonatomic) NSString *appScheme;

// The delegate for SDK manager.
@property (weak, nonatomic) id <NNGSDKDelegate> delegate;

// Set client ID, client secret, and lounge ID for SDK.
- (void)setClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret loungeId:(NSString *)loungeId;

// Set the root view and the delegate for SDK.
- (void)setParentViewController:(UIViewController *)parent;

// Present the banner list.
- (void)presentBannerViewController;

// Present a notice while your game is not on service.
- (void)presentSorryViewController;

// Present the list of feeds identified by a predefined board ID which represents a board.
- (void)presentBoardViewControllerWith:(NSNumber *)boardId;

// Present the feed identified by a feed ID.
- (void)presentFeedViewControllerWith:(NSNumber *)feedId scheduled:(BOOL)scheduled;

// Dismiss all SDK-related views.
- (void)dismiss;

@end


@protocol NNGSDKDelegate <NSObject>

@optional

// The delegate method called when SDK starts.
- (void)nngSDKDidLoad;

// The delegate method called when SDK ends.
- (void)nngSDKDidUnload;

// The delegate method called when a predefined in-game board code is received.
- (void)nngSDKDidReceiveInGameMenuCode:(NSString *)inGameMenuCode;

@end
