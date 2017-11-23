//
//  HighScoreDetailsViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 10/10/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "HighScoreDetailsViewController.h"

@interface HighScoreDetailsViewController()
@property (weak, nonatomic) IBOutlet UIView *hsdContentView;
@property (weak, nonatomic) IBOutlet UILabel *hsTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsPlayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsDateLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation HighScoreDetailsViewController
- (IBAction)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//--Getters and Setters--
#pragma mark Getters and Setters

-(NSDateFormatter *)dateFormatter{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    return _dateFormatter;
}

//--Helper Methods--
#pragma mark Helper Methods

- (NSString *)stringFromTotalPlayTime:(long long)totalPlayTime{
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:totalPlayTime sinceDate:startDate];
    
    NSCalendar *gregCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit totalPlayTimeUnits = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *totalPlayTimeComponents = [gregCalendar components:totalPlayTimeUnits fromDate:startDate toDate:endDate options:0];
    
    NSString *result;
    NSString *dayString;
    NSString *hourString;
    NSString *minuteString;
    NSString *secondString;
    
    if(totalPlayTimeComponents.day == 0)
        dayString = @"";
    else
        dayString = [NSString stringWithFormat:@" %lid", (long)totalPlayTimeComponents.day];
    
    if(totalPlayTimeComponents.hour == 0)
        hourString = @"";
    else
        hourString = [NSString stringWithFormat:@" %lih", (long)totalPlayTimeComponents.hour];
    
    if(totalPlayTimeComponents.minute == 0)
        minuteString = @"";
    else
        minuteString = [NSString stringWithFormat:@" %lim", (long)totalPlayTimeComponents.minute];
    
    secondString = [NSString stringWithFormat:@" %lis", (long)totalPlayTimeComponents.second];
    result = [NSString stringWithFormat:@"%@%@%@%@", dayString,hourString,minuteString,secondString];
    
    return result;
}

- (void)hsdContentViewTapped{
    //Do Nothing
}

//--Setup Code--
#pragma mark Setup Code
- (void)setUp{
    self.hsTagLabel.text = [NSString stringWithFormat:@"High Score Tag: %@", self.highScore.name];
    self.hsValueLabel.text = [NSString stringWithFormat:@"Score: %lli", self.highScore.value];
    self.hsRankLabel.text = [NSString stringWithFormat:@"Rank: %i", self.highScore.rank];
    self.hsPlayTimeLabel.text = [NSString stringWithFormat:@"Total Play Time: %@", [self stringFromTotalPlayTime:self.highScore.totalTime]];
    self.hsDateLabel.text = [NSString stringWithFormat:@"Achieved On: %@", [self.dateFormatter stringFromDate:self.highScore.date]];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)]];
    [self.hsdContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hsdContentViewTapped)]];
}
@end
