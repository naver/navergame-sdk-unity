#import <UIKit/UIKit.h>
#import "UnityAppController.h"
#import <NNGSDK/NNGSDKManager.h>


typedef void (*GLSDKDidLoadDelegate)();
typedef void (*GLSDKDidUnloadDelegate)();


@interface GLinkViewController : UIViewController <NNGSDKDelegate>

@property (nonatomic, strong) UIViewController *mainViewcontroller;

@property (nonatomic, assign) GLSDKDidLoadDelegate glSDKDidLoadDelegate;
@property (nonatomic, assign) GLSDKDidUnloadDelegate glSDKDidUnloadDelegate;

@end


@implementation GLinkViewController

// Set the root view and the delegate for SDK.
- (void)setGLRootViewController {
    _mainViewcontroller = UnityGetGLViewController();
    [NNGSDKManager.shared setParentViewController:_mainViewcontroller];
    [NNGSDKManager.shared setDelegate:self];
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


// Set client ID, client secret, and lounge ID for SDK
- (void)setClientId:(NSString *)clientId clientSecret:(NSString *)cs loungeId:(NSString *)loungeId {
    [NNGSDKManager.shared setClientId:clientId clientSecret:cs loungeId:loungeId];
}


#pragma mark NNGSDKDelegate

// Implementation for the delegate method -nngSDKViewDidLoad.
- (void)nngSDKViewDidLoad {
    if (self.glSDKDidLoadDelegate) {
        self.glSDKDidLoadDelegate();
    }
}


// Implementation for the delegate method -nngSDKViewDidUnload.
- (void)nngSDKViewDidUnload {
    if (self.glSDKDidUnloadDelegate) {
        self.glSDKDidUnloadDelegate();
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

    char* NNGSDKCreateNSStrintToChar (const char* string) {
        if (string == NULL)
            return NULL;
        char* res = (char*) malloc (strlen(string) + 1 );
        strcpy (res, string);
        return res;
    }

    GLinkViewController *vc = [[GLinkViewController alloc] init];

    void _InitGLink(const char* clientId, const char* clientSecret, const char* loungeId) {
        [vc setClientId:NNGSDKCreateNSString(clientId)
           clientSecret:NNGSDKCreateNSString(clientSecret)
               loungeId:NNGSDKCreateNSString(loungeId)];
    }

    void _ExecuteHomeBanner() {
        [vc executeHomeBanner];
    }

    void _ExecuteSorryBanner() {
        [vc executeSorryBanner];
    }

    void _SetSDKDidLoadDelegate(GLSDKDidLoadDelegate glSDKDidLoadDelegate) {
        vc.glSDKDidLoadDelegate = glSDKDidLoadDelegate;
    }

    void _SetSDKDidUnloadDelegate(GLSDKDidUnloadDelegate glSDKDidUnloadDelegate) {
        vc.glSDKDidUnloadDelegate = glSDKDidUnloadDelegate;
    }

}
