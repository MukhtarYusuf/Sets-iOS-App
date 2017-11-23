//
//  AppDelegate.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/9/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultsKeysAndValues.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSDictionary *menuColor;
@property (nonatomic, strong) NSDictionary *saveButtonColor;
@end

@implementation AppDelegate

- (NSUserDefaults *)userDefaults{
    if(!_userDefaults)
        _userDefaults = [NSUserDefaults standardUserDefaults];
    
    return _userDefaults;
}

- (NSDictionary *)settings{
    if([[self.userDefaults objectForKey:WOOD_THEME] boolValue]){
        _settings = @{
                        HAS_BACKGROUND_IMAGE : @YES,
                        BACKGROUND_IMAGE : WOOD_BACKGROUND,
                        CARDBACK_IMAGE : CARDBACK,
                        MENU_COLOR : self.menuColor,
                        SAVE_BUTTON_COLOR : self.saveButtonColor
                      };
    }else if([[self.userDefaults objectForKey:DARK_THEME] boolValue]){
        _settings = @{
                        HAS_BACKGROUND_IMAGE : @YES,
                        BACKGROUND_IMAGE : DARK_BACKGROUND,
                        CARDBACK_IMAGE : CARDBACK_DARK,
                        MENU_COLOR : self.menuColor,
                        SAVE_BUTTON_COLOR : self.saveButtonColor
                      };
    }
    else if([[self.userDefaults objectForKey:CLASSIC_THEME] boolValue]){
        _settings = @{
                        HAS_BACKGROUND_IMAGE : @NO,
                        BACKGROUND_IMAGE : NO_BACKGROUND,
                        CARDBACK_IMAGE : CARDBACK,
                        MENU_COLOR : self.menuColor,
                        SAVE_BUTTON_COLOR : self.saveButtonColor
                      };
    }
    
    return _settings;
}

- (NSDictionary *)menuColor{
    if([[self.userDefaults objectForKey:CLASSIC_THEME] boolValue]){//Menu color for classic theme
        _menuColor = @{
                       RED : [NSNumber numberWithInt:RED_CLASSIC_MENU_VALUE],
                       GREEN : [NSNumber numberWithInt:GREEN_CLASSIC_MENU_VALUE],
                       BLUE : [NSNumber numberWithInt:BLUE_CLASSIC_MENU_VALUE],
                       ALPHA : [NSNumber numberWithDouble:ALPHA_CLASSIC_MENU_VALUE]
                       };
    }else{
        _menuColor = @{
                    RED : [NSNumber numberWithInt:RED_WOOD_MENU_VALUE],
                    GREEN : [NSNumber numberWithInt:GREEN_WOOD_MENU_VALUE],
                    BLUE : [NSNumber numberWithInt:BLUE_WOOD_MENU_VALUE],
                    ALPHA : [NSNumber numberWithDouble:ALPHA_WOOD_MENU_VALUE]
                   };
    }
    
    return _menuColor;
}

- (NSDictionary *)saveButtonColor{
    if([[self.userDefaults objectForKey:CLASSIC_THEME] boolValue]){
        _saveButtonColor = @{
                             RED : [NSNumber numberWithInt:RED_CLASSIC_SAVE_BUTTON_VALUE],
                             GREEN : [NSNumber numberWithInt:GREEN_CLASSIC_SAVE_BUTTON_VALUE],
                             BLUE : [NSNumber numberWithInt:BLUE_CLASSIC_SAVE_BUTTON_VALAUE],
                             ALPHA : [NSNumber numberWithDouble:ALPHA_CLASSIC_SAVE_BUTTON_VALUE]
                             };
    }else{
        _saveButtonColor = @{
                             RED : [NSNumber numberWithInt:RED_WOOD_SAVE_BUTTON_VALUE],
                             GREEN : [NSNumber numberWithInt:GREEN_WOOD_SAVE_BUTTON_VALUE],
                             BLUE : [NSNumber numberWithInt:BLUE_WOOD_SAVE_BUTTON_VALUE],
                             ALPHA : [NSNumber numberWithDouble:ALPHA_WOOD_SAVE_BUTTON_VALUE]
                             };
    }
    
    return _saveButtonColor;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if(![self.userDefaults objectForKey:APP_LAUNCHED_ONCE]){//App is launching for the first time
        [self.userDefaults setBool:YES forKey:APP_LAUNCHED_ONCE];
        [self.userDefaults setBool:YES forKey:WOOD_THEME];
        [self.userDefaults setBool:NO forKey:DARK_THEME];
        [self.userDefaults setBool:NO forKey:CLASSIC_THEME];
        [self.userDefaults synchronize];
        [self.userDefaults setObject:self.settings forKey:SETTINGS];
        [self.userDefaults synchronize];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
