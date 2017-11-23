//
//  PlayingCardView.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/9/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat cardFaceScaleFactor;
@end

@implementation PlayingCardView

#define DEFAULT_CARD_FACE_SCALE_FACTOR 0.90

//--Handle Getters and Setters--

@synthesize cardFaceScaleFactor = _cardFaceScaleFactor;

- (CGFloat)cardFaceScaleFactor{
    if(!_cardFaceScaleFactor)
        _cardFaceScaleFactor = DEFAULT_CARD_FACE_SCALE_FACTOR;
    return _cardFaceScaleFactor;
}

- (void)setCardFaceScaleFactor:(CGFloat)cardFaceScaleFactor{
    _cardFaceScaleFactor = cardFaceScaleFactor;
    [self setNeedsDisplay];
}

- (void)setCardBackImageName:(NSString *)cardBackImageName{
    _cardBackImageName = cardBackImageName;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUP:(BOOL)faceUP{
    _faceUP = faceUP;
    [self setNeedsDisplay];
}

-(void)setIsMatched:(BOOL)isMatched{
    _isMatched = isMatched;
    [self setNeedsDisplay];
}

- (NSString *)rankAsString{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

//--Handle Drawing--

#define CENTER_FONT_HEIGHT 80.0
#define CORNER_FONT_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)centerScaleFactor{
    return (self.bounds.size.height/CENTER_FONT_HEIGHT);
}
- (CGFloat)cornerScaleFactor{
    return (self.bounds.size.height/CORNER_FONT_HEIGHT);
}
- (CGFloat)cornerRadius{
    return (CORNER_RADIUS * [self cornerScaleFactor]);
}
- (CGFloat)cornerOffset{
    return ([self cornerRadius] / 3.0);
}


//Override drawRect: to Perform Custom Drawing
- (void) drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if(self.faceUP){
        [self drawCorners];
        [self drawCenter];
    }else{
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
    
    if(self.isMatched)
        self.alpha = 0.5;
    else
        self.alpha = 1;
}

-(void)drawCorners{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString],[self suit]]
                                                                     attributes:@{
                                                                                  NSParagraphStyleAttributeName : paragraphStyle,
                                                                                  NSFontAttributeName : cornerFont
                                                                                  }];
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = cornerText.size;
    [cornerText drawInRect:textBounds];
    
    [self saveContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

-(void)drawCenter{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *centerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    centerFont = [centerFont fontWithSize:centerFont.pointSize * [self centerScaleFactor]];
    
    NSAttributedString *centerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [self rankAsString], [self suit]]
                                                                     attributes:@{
                                                                                  NSParagraphStyleAttributeName : paragraphStyle,
                                                                                  NSFontAttributeName : centerFont
                                                                                  }];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint centerTextOrigin = CGPointMake(center.x-(centerText.size.width/2), center.y-(centerText.size.height/2));
    
    [centerText drawAtPoint:centerTextOrigin];
}

- (void) saveContextAndRotateUpsideDown{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void) popContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

//--Handle Setup and Initialization--

- (void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
