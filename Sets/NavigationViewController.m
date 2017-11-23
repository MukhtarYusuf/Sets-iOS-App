//
//  NavigationViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 10/20/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "NavigationViewController.h"
#import "CardGameViewController.h"
#import "HelpViewController.h"

@interface NavigationViewController()
@end

@implementation NavigationViewController

-(BOOL)shouldAutorotate{
    UIViewController *topViewController = self.topViewController;
    
    if([topViewController isKindOfClass:[CardGameViewController class]]){
        return NO;
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *topViewController = self.topViewController;
    
    if([topViewController isKindOfClass:[CardGameViewController class]]){
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskAll;
}
@end

