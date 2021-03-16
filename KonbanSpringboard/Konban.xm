#import "Konban.h"

@implementation Konban

+(SBApplication *)app:(NSString *)bundleID {
    return [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:bundleID];
}

+(UIView *)viewFor:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban launch:bundleID];
    [Konban forceBackgrounded:NO forApp:app];
    FBScene *scene = [Konban getMainSceneForApp:app];
    [Konban wakeScene:scene];

    return [Konban createLayerHostView:bundleID];

}
+(void)launch:(NSString *)bundleID {
  [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:YES]; // When launching the app suspended, it doesn't appear for the user.
}

+(void)wakeScene:(FBScene *)scene {
  [scene _setContentState:2]; // 2 == ready, 1 == preparing, 0 == not ready
  FBSMutableSceneSettings *sceneSettings = scene.mutableSettings;
  [sceneSettings setForeground:YES]; // This is important for the view to be interactable.
  [scene updateSettings:sceneSettings withTransitionContext:nil]; // Enact the changes made
}

+(void)sleepScene:(FBScene *)scene {
  [scene _setContentState:0]; //2 == ready, 1 == preparing, 0 == not ready
  FBSMutableSceneSettings *sceneSettings = scene.mutableSettings;
  [sceneSettings setForeground:NO];
  [scene updateSettings:sceneSettings withTransitionContext:nil]; // Enact the changes made
}

+(void)forceBackgrounded:(BOOL)backgrounded forApp:(SBApplication *)app {
  FBScene *scene = [Konban getMainSceneForApp:app];
  FBSMutableSceneSettings *sceneSettings = scene.mutableSettings;
  [sceneSettings setBackgrounded:backgrounded];
  [scene updateSettings:sceneSettings withTransitionContext:nil];
}

+(id)createLayerHostView:(NSString *)bundleID { // This is the new implementation to get the view instead of getting it via a FBSceneHostManager which was the old way.
  SBApplication *app = [Konban app:bundleID];
  FBScene *scene = [Konban getMainSceneForApp:app];
  _UISceneLayerHostContainerView *layerHostView=[[objc_getClass("_UISceneLayerHostContainerView") alloc] initWithScene:scene];
  [layerHostView _setPresentationContext:[[objc_getClass("UIScenePresentationContext") alloc] _initWithDefaultValues]];
  return layerHostView;
}

+(void)rehost:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban launch:bundleID];
    [Konban forceBackgrounded:NO forApp:app];
    [Konban wakeScene:[Konban getMainSceneForApp:app]];
}

+(void)dehost:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban forceBackgrounded:YES forApp:app];
    [Konban sleepScene:[Konban getMainSceneForApp:app]];
}

+ (FBScene *)getMainSceneForApp:(SBApplication *)app {
    NSDictionary *scenes = MSHookIvar<NSDictionary *>([%c(FBSceneManager) sharedInstance], "_scenesByID");
    for(NSString *identifier in [scenes allKeys]){
        if([identifier containsString:app.bundleIdentifier]){
            if ([scenes[identifier] isKindOfClass:[%c(FBScene) class]]) {
                return scenes[identifier];
            }
        }
    }
    return nil;
}

@end
