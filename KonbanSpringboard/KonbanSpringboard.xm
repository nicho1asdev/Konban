#import "KonbanSpringboard.h"
#import "Konban.h"
#import <AppList/AppList.h>

@interface UIScene ()
-(id)_identifier;
@end

HBPreferences *preferences;
BOOL dpkgInvalid = false;
BOOL visible = NO;
BOOL enabled;
BOOL enabledCoverSheet;
BOOL enabledHomeScreen;
BOOL hideStatusBar;
CGFloat scale = 0.8;
CGFloat cornerRadius = 16;
NSString *bundleID = @"com.apple.calculator";
UIViewController *ourVC = nil;

CGRect insetByPercent(CGRect f, CGFloat s) {
    CGFloat originScale = (1.0 - s)/2.0;
    return CGRectMake(f.origin.x + f.size.width * originScale, f.origin.y + f.size.height * originScale, f.size.width * s, f.size.height * s);
}

%group Konban

%hook SBHomeScreenTodayViewController

%property (nonatomic, retain) UIView *konHostView;
%property (nonatomic, retain) UIActivityIndicatorView *konSpinnerView;
%property (nonatomic, retain) UIStackView *konFavStackView;

-(void)viewWillAppear:(bool)arg1 {
    %orig;

    [self.konSpinnerView stopAnimating];
    [self.konSpinnerView removeFromSuperview];
    [self.konHostView removeFromSuperview];

    if (enabled) {
        for (UIView *view in [self.view subviews]) {
            view.hidden = YES;
        }

        if (!self.konSpinnerView) self.konSpinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.konSpinnerView.hidesWhenStopped = YES;
        self.konSpinnerView.frame = self.view.frame;
        [self.view addSubview:self.konSpinnerView];
        [self.konSpinnerView startAnimating];

        visible = YES;
        @try {
        [Konban launch:bundleID];
        self.konHostView = [Konban viewFor:bundleID]; //prevent crashes by putting it in a try-catch block. While the app is loading, the FBSceneLayer will return nil, which will cause a crash.
        }
        @catch (NSException *exception){
          if (exception) {
            %log(@"konView ERROR:%@", exception);
          }
        }
        %log(@"[konban] konHostView: %@", self.konHostView);
        self.konHostView.alpha = 0;
        self.konHostView.frame = self.view.frame;
        self.konHostView.transform = CGAffineTransformMakeScale(scale, scale);
        self.konHostView.layer.cornerRadius = cornerRadius;
        self.konHostView.layer.masksToBounds = true;
        [self.view addSubview:self.konHostView];
        [self.view bringSubviewToFront:self.konHostView];
        self.konHostView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
          self.konHostView.alpha = 1;
        }];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.konban/StatusBarHide", nil, nil, true);

        if (!self.konHostView) { // loop through these steps until the application is launched and our view is returned.
            [self.konSpinnerView startAnimating];
            [self.view bringSubviewToFront:self.konSpinnerView];

            [self performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:0.5];
        }
    } else {
        for (UIView *view in [self.view subviews]) {
            view.hidden = NO;
        }

        if (self.konHostView) {
            [self.konHostView removeFromSuperview];
            [Konban dehost:bundleID];
            self.konHostView = nil;
        }
    }
}

-(void)viewDidDisappear:(bool)arg1 {
    %orig;
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.konban/StatusBarShow", nil, nil, true);

    visible = NO;
    if (!self.konHostView) return;
    [self.konHostView removeFromSuperview];
    [Konban dehost:bundleID];
    self.konHostView = nil;
}

%end

%end

%group dpkgInvalid

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (dpkgInvalid) {
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Konban you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Konban is free. Uninstall this build and install the proper version of Konban from:\nhttps://nicho1asdev.github.io/repo\n(it's free, damnit, why would you pirate that!?)"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        [((UIApplication*)self) openURL:[NSURL URLWithString:@"https://nicholasdev.github.io/repo/"] options:@{} completionHandler:nil];
    }]];

    [((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
  }
}

%end

%end

void changeApp() {
    NSMutableDictionary *appList = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.nepeta.konban-app.plist"];
    if (!appList) return;

    if ([appList objectForKey:@"App"]) {
        bundleID = [appList objectForKey:@"App"];
    }
}

%ctor{
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.konban"];
    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerFloat:&cornerRadius default:16 forKey:@"CornerRadius"];
    [preferences registerFloat:&scale default:0.8 forKey:@"Scale"];
    [preferences registerBool:&hideStatusBar default:YES forKey:@"HideStatusBar"];
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.nicho1asdev.konban.list"];

    if (dpkgInvalid) %init(dpkgInvalid);

    changeApp();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)changeApp, (CFStringRef)@"me.nepeta.konban/ReloadApp", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    %init(Konban);
}
