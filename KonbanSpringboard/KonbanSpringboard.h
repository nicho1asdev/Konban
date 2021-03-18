#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <Cephei/HBPreferences.h>
#import "../headers/FBScene.h"

@interface SBRootFolderView : UIView

-(UIViewController *)todayViewController;

@end

@interface SBHomeScreenTodayViewController : UIViewController

@property (nonatomic, retain) UIView *konHostView;
@property (nonatomic, retain) UIActivityIndicatorView *konSpinnerView;
@property (nonatomic, retain) UIStackView *konFavStackView;

- (void)setupFavoritesView;

@end

@interface SBDashBoardTodayViewController : UIViewController

@property (nonatomic, retain) UIView *konHostView;
@property (nonatomic, retain) UIActivityIndicatorView *konSpinnerView;

@end

@interface SBTodayViewController : UIViewController

@property (nonatomic, retain) UIView *konHostView;
@property (nonatomic, retain) UIActivityIndicatorView *konSpinnerView;
@property (nonatomic, retain) UIStackView *konFavStackView;

- (void)setupFavoritesView;

@end

@interface CSTodayContentViewController : UIViewController

@property (nonatomic, retain) UIView *konHostView;
@property (nonatomic, retain) UIActivityIndicatorView *konSpinnerView;

@end

@interface SBFUserAuthenticationController
	- (void)_setAuthState:(long long)arg1;
@end

@interface SBDeviceApplicationSceneHandle
	-(FBScene *)scene;
@end
