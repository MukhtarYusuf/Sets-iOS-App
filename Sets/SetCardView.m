//
//  SetCardView.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/16/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardView.h"
@interface SetCardView()
@property (strong, nonatomic) NSDictionary *colors;
@end

@implementation SetCardView

//--Handle Getters and Setters--

-(NSDictionary *)colors{
    if(!_colors)
        _colors = @{
                    @"Red" : [UIColor redColor],
                    @"Green" : [UIColor greenColor],
                    @"Blue" : [UIColor blueColor]
                    };
    return _colors;
}

-(void)setShape:(NSString *)shape{
    _shape = shape;
    [self setNeedsDisplay];
}

-(void)setColor:(NSString *)color{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setShading:(NSString *)shading{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setNumber:(int)number{
    _number = number;
    [self setNeedsDisplay];
}
-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}
-(void)setIsChosen:(BOOL)isChosen{
    _isChosen = isChosen;
    [self setNeedsDisplay];
}
- (void)setIsMatched:(BOOL)isMatched{
    _isMatched = isMatched;
    [self setNeedsDisplay];
}

//--Handle Drawing--

#define CORNER_HEIGHT 180.0
#define CORNER_RADIUS 12.0

#define SHAPE_HEIGHT_RATIO 0.18
#define SHAPE_WIDTH_RATIO 0.68

#define STROKE_SPACE_RATIO 0.04

-(CGFloat)cornerScaleFactor{
    return (self.bounds.size.height/CORNER_HEIGHT);
}
-(CGFloat)cornerRadius{
    return (CORNER_RADIUS * [self cornerScaleFactor]);
}
-(CGFloat)shapeHeightScaleFactor{
    return (SHAPE_HEIGHT_RATIO * self.bounds.size.height);
}
-(CGFloat)shapeWidthScaleFactor{
    return (SHAPE_WIDTH_RATIO * self.bounds.size.width);
}
-(CGFloat)distanceBetweenShapesFactor{
    return 1.5 * [self shapeHeightScaleFactor];
}

//Override drawRect: to perform custom drawing
-(void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    if(!self.isChosen)
        [[UIColor whiteColor] setFill];
    else
        [[UIColor cyanColor] setFill];
    
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if(_faceUp){
        if([self.shape isEqualToString:@"Diamond"])
            [self drawAllDiamonds];
        else if([self.shape isEqualToString:@"Oval"])
            [self drawAllOvals];
        else if([self.shape isEqualToString:@"Squiggle"])
            [self drawAllSquiggles];
    }else{
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
    
    if(self.isMatched)
        self.alpha = 0.0;
    else
        self.alpha = 1.0;
}

-(void)drawAllDiamonds{
    switch (self.number){
        case 1:
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:0.0];
            break;
        case 2:
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:-1*[self distanceBetweenShapesFactor]/2];
            
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:[self distanceBetweenShapesFactor]/2];
            break;
            
        case 3:
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:-1*[self distanceBetweenShapesFactor]];
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:0];
            [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:[self distanceBetweenShapesFactor]];
            break;
            
        default:
            break;
    }
}

//Because oval startpoint is at the top left corner and not middle left, adjustments have to be made with spacing for consistency
-(void)drawAllOvals{
    switch (self.number){
        case 1:
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self shapeHeightScaleFactor]/2)];
            break;
        case 2:
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self distanceBetweenShapesFactor]/2) - ([self shapeHeightScaleFactor]/2)];
            
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:([self distanceBetweenShapesFactor]/2) - ([self shapeHeightScaleFactor]/2)];
            break;
        case 3:
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self distanceBetweenShapesFactor]) - ([self shapeHeightScaleFactor]/2)];
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self shapeHeightScaleFactor]/2)];
            [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:([self distanceBetweenShapesFactor]) - ([self shapeHeightScaleFactor]/2)];
            break;
        default:
            break;
    }
}

-(void)drawAllSquiggles{
    switch (self.number){
        case 1:
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:0.0];
            break;
        case 2:
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:-1*[self distanceBetweenShapesFactor]/2];
            
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:[self distanceBetweenShapesFactor]/2];
            break;
        case 3:
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:-1*[self distanceBetweenShapesFactor]];
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:0];
            [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:[self distanceBetweenShapesFactor]];
            break;
        default:
            break;
    }
}

-(void)drawSquiggleAt: (CGFloat)hOffset and:(CGFloat)vOffset{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffset, center.y + vOffset);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];
    
    CGPoint originOfRect = CGPointMake(startPoint.x, startPoint.y-shapeHeight/2);
    CGSize sizeOfRect = CGSizeMake(shapeWidth, shapeHeight);
    CGRect enclosingRect;
    enclosingRect.origin = originOfRect;
    enclosingRect.size = sizeOfRect;

    
    //9 Curves are needed to draw squiggle. Create an array of points for each curve
    NSArray *curve0 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y-0.38*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.01*shapeWidth, startPoint.y - 0.2*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.1*shapeWidth, startPoint.y - 0.35*shapeHeight)]
                        ];
    
    NSArray *curve1 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.45*shapeWidth, startPoint.y-0.35*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.2*shapeWidth, startPoint.y - 0.44*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.3*shapeWidth, startPoint.y - 0.44*shapeHeight)]
                        ];
    
    
    NSArray *curve2 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.85*shapeWidth, startPoint.y-0.45*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.6*shapeWidth, startPoint.y - 0.25*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.75*shapeWidth, startPoint.y - 0.25*shapeHeight)]
                        ];
    
    NSArray *curve3 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.95*shapeWidth, startPoint.y-0.2*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.9*shapeWidth, startPoint.y - 0.5*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.955*shapeWidth, startPoint.y - 0.4*shapeHeight)]
                        ];
    
    NSArray *curve4 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.8*shapeWidth, startPoint.y+0.32*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.92*shapeWidth, startPoint.y + 0.2*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.85*shapeWidth, startPoint.y + 0.3*shapeHeight)]
                        ];
    NSArray *curve5 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.355*shapeWidth, startPoint.y+0.29*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.65*shapeWidth, startPoint.y + 0.42*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.45*shapeWidth, startPoint.y + 0.3*shapeHeight)]
                        ];
    NSArray *curve6 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y+0.425*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.18*shapeWidth, startPoint.y + 0.30*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y + 0.45*shapeHeight)]
                        ];
    
    NSArray *curve7 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.01*shapeWidth, startPoint.y+0.2*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.1*shapeWidth, startPoint.y + 0.50*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.04*shapeWidth, startPoint.y + 0.4*shapeHeight)]
                        ];
    
    NSArray *curve8 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.0*shapeWidth, startPoint.y+0.0*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.0*shapeWidth, startPoint.y + 0.15*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.0*shapeWidth, startPoint.y + 0.1*shapeHeight)]
                        ];;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:startPoint];
    
    [bezierPath addCurveToPoint:((NSValue *)curve0[0]).CGPointValue controlPoint1:((NSValue *)curve0[1]).CGPointValue controlPoint2:((NSValue *)curve0[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve1[0]).CGPointValue controlPoint1:((NSValue *)curve1[1]).CGPointValue controlPoint2:((NSValue *)curve1[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve2[0]).CGPointValue controlPoint1:((NSValue *)curve2[1]).CGPointValue controlPoint2:((NSValue *)curve2[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve3[0]).CGPointValue controlPoint1:((NSValue *)curve3[1]).CGPointValue controlPoint2:((NSValue *)curve3[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve4[0]).CGPointValue controlPoint1:((NSValue *)curve4[1]).CGPointValue controlPoint2:((NSValue *)curve4[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve5[0]).CGPointValue controlPoint1:((NSValue *)curve5[1]).CGPointValue controlPoint2:((NSValue *)curve5[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve6[0]).CGPointValue controlPoint1:((NSValue *)curve6[1]).CGPointValue controlPoint2:((NSValue *)curve6[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve7[0]).CGPointValue controlPoint1:((NSValue *)curve7[1]).CGPointValue controlPoint2:((NSValue *)curve7[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve8[0]).CGPointValue controlPoint1:((NSValue *)curve8[1]).CGPointValue controlPoint2:((NSValue *)curve8[2]).CGPointValue];
    
    bezierPath.lineWidth = 1.5;
    
    [self.colors[self.color] setStroke];
    [bezierPath stroke];
    if([self.shading isEqualToString:@"Solid"])
        [self.colors[self.color] setFill];
    else
        [[UIColor whiteColor] setFill];
    
    [bezierPath fill];
    
    [bezierPath addClip];
    
    if([self.shading isEqualToString:@"Striped"])
        [self addStrokeToRect:enclosingRect];
    
    
    [self restoreContext];
}

#define OVAL_CORNER_RADIUS_RATIO 0.3

-(void)drawOvalAt: (CGFloat)hOffSet and:(CGFloat)vOffSet{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffSet, center.y + vOffSet);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];
    
    CGSize sizeOfRect = CGSizeMake(shapeWidth, shapeHeight);
    CGRect enclosingRect;
    enclosingRect.origin = startPoint;
    enclosingRect.size = sizeOfRect;
    
    CGFloat ovalCornerRadius = shapeWidth * OVAL_CORNER_RADIUS_RATIO;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:enclosingRect cornerRadius:ovalCornerRadius];
    bezierPath.lineWidth = 3.0;
    
    [self.colors[self.color] setStroke];
    [bezierPath stroke];
    if([self.shading isEqualToString:@"Solid"])
        [self.colors[self.color] setFill];
    else
        [[UIColor whiteColor] setFill];
    
    [bezierPath fill];
    
    [bezierPath addClip];
    
    if([self.shading isEqualToString:@"Striped"])
        [self addStrokeToRect:enclosingRect];
    
    [self restoreContext];
}

-(void)drawDiamondAt: (CGFloat)hOffSet and: (CGFloat)vOffSet{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffSet, center.y + vOffSet);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];
    
    CGFloat halfHeight = shapeHeight/2;
    CGFloat halfWidth = shapeWidth/2;
    
    CGPoint originOfRect = CGPointMake(startPoint.x, startPoint.y-halfHeight);
    CGSize sizeOfRect = CGSizeMake(shapeWidth, shapeHeight);
    CGRect enclosingRect;
    enclosingRect.origin = originOfRect;
    enclosingRect.size = sizeOfRect;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    bezierPath.lineWidth = 2.0;
    [bezierPath moveToPoint:startPoint];
    
    CGPoint topCorner = CGPointMake(startPoint.x + halfWidth, startPoint.y - halfHeight);
    
    CGPoint rightCorner = CGPointMake(topCorner.x + halfWidth, topCorner.y+halfHeight);
    
    CGPoint bottomCorner = CGPointMake(rightCorner.x - halfWidth, rightCorner.y + halfHeight);
    
    [bezierPath addLineToPoint:topCorner];
    [bezierPath addLineToPoint:rightCorner];
    [bezierPath addLineToPoint:bottomCorner];
    [bezierPath closePath];
    
    [self.colors[self.color] setStroke];
    [bezierPath stroke];
    if([self.shading isEqualToString:@"Solid"])
        [self.colors[self.color] setFill];
    else
        [[UIColor whiteColor] setFill];
    
    [bezierPath fill];
    
    [bezierPath addClip];

    if([self.shading isEqualToString:@"Striped"]){
        [self addStrokeToRect:enclosingRect];
    }
    
//    UIColor *fillandStrokeColor = self.colors[self.color];
//    
//    [fillandStrokeColor setStroke];
//    [bezierPath stroke];
//    
//    if(![self.shading isEqualToString:@"Open"]){
//        [fillandStrokeColor setFill];
//        [bezierPath fill];
//    }else{
//        [[UIColor whiteColor] setFill];
//        [bezierPath fill];
//    }
    
    [self restoreContext];
}

-(void)addStrokeToRect:(CGRect)aRect{
    [self saveContext];
    CGFloat strokeSpacing = STROKE_SPACE_RATIO * aRect.size.width;
    CGFloat topBoundary = aRect.origin.y;
    CGFloat bottomBoundary = aRect.origin.y + aRect.size.height;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    bezierPath.lineWidth = 0.4;
    for(double i = aRect.origin.x; i < (aRect.origin.x + aRect.size.width); i+=strokeSpacing){
        [bezierPath moveToPoint:CGPointMake(i, topBoundary)];
        [bezierPath addLineToPoint:CGPointMake(i, bottomBoundary)];
    }
    [bezierPath stroke];
    [self restoreContext];
}

-(void)saveContext{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}
-(void)restoreContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

//--Handle Setup and Initialization--

-(void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.faceUp = YES;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
