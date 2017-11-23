//
//  HelpViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 8/25/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController()
@property (weak, nonatomic) IBOutlet UIView *helpContentView;
@end

@implementation HelpViewController
- (IBAction)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showText:(id)sender {
    [self displayFadingText];
}

-(void)displayFadingText{
    
    UILabel *label;
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    
    CGFloat midX = screenWidth/2.0;
    CGFloat midY = screenHeight/2.0;
    
    CGRect labelFrame;
    CGRect labelFrame2;
    
    labelFrame.origin = CGPointMake(0.0, 0.0);
    labelFrame.size = CGSizeMake(40.0, 40.0);
    
    labelFrame2.origin = CGPointMake(0.0, 0.0);
    labelFrame2.size = CGSizeMake(100.0, 100.0);
    
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.center = CGPointMake(midX, midY);
    label.text = @"Hello";
    label.textColor = [UIColor greenColor];
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1
                     animations:^{
                         label.alpha = 0.0;
                         label.frame = labelFrame2;
                         label.font = [label.font fontWithSize:30];
                     }
                     completion:^(BOOL finished) {
                         [label removeFromSuperview];
                     }];
}

- (void)helpContentViewTapped{
    //Do Nothing
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)]];
    [self.helpContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpContentViewTapped)]];
}

@end
