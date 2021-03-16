#import "../headers/FBScene.h"
#import "../headers/SBApplication.h"
#import "../headers/SBApplicationController.h"

@interface FBSceneManager : NSObject
+ (id)sharedInstance;
- (id)sceneWithIdentifier:(NSString *)arg1;
- (void)_noteSceneMovedToForeground:(id)arg1;
@end

@interface FBSceneLayerManager
@property (nonatomic)NSHashTable *_observers;
@property (nonatomic, strong)NSHashTable *layers;
@end

@interface _UIContextLayerHostView : UIView
- (id)initWithSceneLayer:(id)arg1;
@end

@interface _UISceneLayerHostContainerView : UIView
- (id)initWithScene:(id)arg1;
- (void)_setPresentationContext:(id)arg1;
@end

@interface UIScenePresentationContext : NSObject
- (id)_initWithDefaultValues;
@end

@interface FBSceneLayer : NSObject
@end

@interface FBSMutableSceneSettings (Private)
- (void)setIdleModeEnabled:(BOOL)arg1;
- (void)setForeground:(BOOL)arg1;
@end

@interface UIApplication(Private)
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
@end

@interface Konban : NSObject

+(SBApplication *)app:(NSString *)bundleID;
+(UIView *)viewFor:(NSString *)bundleID;
+(void)launch:(NSString *)bundleID;
+(void)forceBackgrounded:(BOOL)backgrounded forApp:(SBApplication *)app;
+(void)rehost:(NSString *)bundleID;
+(void)dehost:(NSString *)bundleID;
+(void)wakeScene:(id)scene;
+(void)sleepScene:(id)scene;
+ (FBScene *)getMainSceneForApp:(SBApplication *)application;

@end
