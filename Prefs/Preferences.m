#import "Preferences.h"

@implementation KONPrefsListController

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed: 0.60 green: 0.20 blue: 1.00 alpha: 1.00];
        // appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Prefs" target:self] retain];

        if (@available(iOS 14.0, *)) {
          NSMutableArray *mutableSpecifiers = [_specifiers mutableCopy];
          PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"iOS 14" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
          [specifier setProperty:@"iOS 14" forKey:@"label"];
          [mutableSpecifiers insertObject:specifier atIndex:9];

          PSSpecifier *useAppLibrarySpecifier = [PSSpecifier preferenceSpecifierNamed:@"Allow in notification center" target:self set:@selector(setPreferenceValue: specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
          [useAppLibrarySpecifier setProperty:@"Allow in notification center" forKey:@"label"];
          [useAppLibrarySpecifier setProperty:@"me.nepeta.konban.plist" forKey:@"defaults"];
          [useAppLibrarySpecifier setProperty:@"useInNotificationCenter" forKey:@"key"];
          [useAppLibrarySpecifier setProperty:@true forKey:@"default"];
          [useAppLibrarySpecifier setProperty:@1 forKey:@"enabled"];
          [mutableSpecifiers insertObject:useAppLibrarySpecifier atIndex:10];
          _specifiers = [mutableSpecifiers copy];
        }
    }
    return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
}

- (void)respring:(id)sender {
    NSTask *t = [[[NSTask alloc] init] autorelease];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"-9", @"SpringBoard", nil]];
    [t launch];
}
@end
