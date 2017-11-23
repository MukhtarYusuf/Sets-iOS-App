//
//  RoundedModalContentView.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 8/31/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "RoundedModalContentView.h"

@interface RoundedModalContentView()
@end

@implementation RoundedModalContentView

#define HEIGHT_SCALE_FACTOR 180.0
#define CORNER_RADIUS 8.0

-(UIColor *)mecuryColorWithAlpha{
    return [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:0.96];
}

-(CGFloat)cornerRadius{
    return CORNER_RADIUS * (self.bounds.size.height/HEIGHT_SCALE_FACTOR);
}

-(void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[self mecuryColorWithAlpha] setFill];
    [roundedRect fill];
    
    [[UIColor whiteColor] setStroke];
    [roundedRect stroke];
}

-(void)setUp{
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = nil;
    self.opaque = NO;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUp];
    
    return self;
}
@end
