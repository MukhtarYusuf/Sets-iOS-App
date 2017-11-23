//
//  HighScoreDetailsController.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 10/10/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScore+CoreDataProperties.h"

@interface HighScoreDetailsViewController : UIViewController
@property (strong, nonatomic) HighScore *highScore;
@end
