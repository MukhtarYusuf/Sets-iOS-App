//
//  PlahingCardView.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/9/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUP;
@property (nonatomic) BOOL isMatched;
@property (strong, nonatomic) NSString *cardBackImageName;

@end
