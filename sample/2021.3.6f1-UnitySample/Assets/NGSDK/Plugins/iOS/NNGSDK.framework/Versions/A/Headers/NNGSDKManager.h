// NAVER Game SDK for iOS
// Copyright 2021-present NAVER Corp.
//
// Unauthorized use, modification and redistribution of this software are strongly prohibited.
//
// Created by Alan on 2021/02/25.


#import <Foundation/Foundation.h>


@protocol NNGSDKDelegate;
@class UIViewController, UIImage;


@interface NNGSDKManager : NSObject

/**
 * The singleton instance of SDK manager.
 */
@property (class, nonatomic, readonly) NNGSDKManager *shared;

/**
 * Your client ID.
 */
@property (strong, nonatomic, readonly) NSString *clientId;

/**
 * Your client Secret.
 */
@property (strong, nonatomic, readonly) NSString *clientSecret;

/**
 * Your lounge ID.
 */
@property (strong, nonatomic, readonly) NSString *loungeId;

/**
 * The ISO_3166-1 alpha-2 country code of each device.
 */
@property (strong, nonatomic, readonly) NSString *countryCode;

/**
 * The version of the SDK.
 */
@property (strong, nonatomic, readonly) NSString *version;

/**
 * Your App Name. It is initialized automatically by using CFBundleName.
 */
@property (nonatomic) NSString *appName;

/**
 * Your App Scheme. It is initialized automatically.
 */
@property (nonatomic) NSString *appScheme;

/**
 * The flag which determines whether the shortcut to write feed is presented after capturing screen or not. YES as default.
 */
@property (assign, nonatomic) BOOL canWriteFeedByScreenshot;

/**
 * The delegate for SDK manager.
 */
@property (weak, nonatomic) id <NNGSDKDelegate> delegate;

/**
 * The description of settings for the authorization which has the following format:
 *
 * clientId: ACTUAL_CLIENT_ID (CLIENT_ID_CACHE)
 * clientSecret: ACTUAL_CLIENT_SECRET (CLIENT_SECRET_CACHE)
 * appName: ACTUAL_APP_NAME (APP_NAME_CACHE)
 * appScheme: ACTUAL_APP_SCHEME (APP_SCHEME_CACHE)
 *
 * Each actual value, cache, and the value on the NAVER ID Login website have to be same.
 */
@property (nonatomic, readonly) NSString *authSettingDescription;

/**
 * Set client ID, client secret, and lounge ID for SDK.
 *
 * @param clientId  Client ID. (Required)
 * @param clientSecret  Client secret. (Required)
 * @param loungeId  Lounge ID. (Required)
 */
- (void)setClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret loungeId:(NSString *)loungeId;

/**
 * Set the root view for SDK.
 *
 * @param parent  Parent view controller for SDK views. (Required)
 */
- (void)setParentViewController:(UIViewController *)parent;

/**
 * Register the game ID of current member.
 *
 * @param memberGameId  Game ID of current member. (Required)
 */
- (void)registerMemberGameId:(NSString *)memberGameId;

/**
 * Present banners.
 */
- (void)presentBannerViewController;

/**
 * Present a notice while your game is not on service.
 */
- (void)presentSorryViewController;

/**
 * Present the a board.
 *
 * @param boardId   Board ID. You can find it in the webpage URL of a board of the form https://game.naver.com/lounge/{loungeId}/board/{boardId}. If it is null or 0, the board of all feed will present. (Optional)
 */
- (void)presentBoardViewControllerWith:(NSNumber *)boardId;

/**
 * Present a feed.
 *
 * @param feedId    Feed ID. You can find it in the webpage URL of a feed of the form https://game.naver.com/lounge/{loungeId}/board/detail/{feedId}. (Required)
 * @param scheduled Flag which determines whether the feed to present is scheduled of not. (Required)
 */
- (void)presentFeedViewControllerWith:(NSNumber *)feedId scheduled:(BOOL)scheduled;

/**
 * Present the feed writing view.
 * Every parameter is just predefined value for feed writing view to present, so each one is optional.
 *
 * @param boardId   Predefined board ID of the board to contain new feed. You can find it in the webpage URL of a board of the form https://game.naver.com/lounge/{loungeId}/board/{boardId}. (Optional)
 * @param title   Predefined title of new feed. (Optional)
 * @param text   Predefined text content of new feed. (Optional)
 * @param imageFilePath   File path for predefined attached image of new feed. Only 1 image can be attached on feed written by using SDK. (Optional)
 */
- (void)presentFeedWritingWithBoardId:(NSNumber *)boardId title:(NSString *)title text:(NSString *)text imageFilePath:(NSString *)imageFilePath;

/**
 * Dismiss all SDK-related views.
 */
- (void)dismiss;

/**
 * Logout
 */
- (void)logout;

/**
 * Handle callback urls for the Naver login.
 *
 * @param url   Callback URL from Naver login service.
 */
- (BOOL)handleCallbackUrl:(NSURL *)url;

@end


@protocol NNGSDKDelegate <NSObject>

@optional

/**
 * The delegate method called when SDK starts.
 */
- (void)nngSDKDidLoad;

/**
 * The delegate method called when SDK ends.
 */
- (void)nngSDKDidUnload;

/**
 * The delegate method called when a predefined in-game board code is received.
 */
- (void)nngSDKDidReceiveInGameMenuCode:(NSString *)inGameMenuCode;

@end
