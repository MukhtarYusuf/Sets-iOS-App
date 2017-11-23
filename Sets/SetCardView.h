//
//  SetCardView.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/16/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) int number;
@property (nonatomic) BOOL isChosen;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL isMatched;

@end
