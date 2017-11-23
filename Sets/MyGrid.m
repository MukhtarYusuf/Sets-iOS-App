//
//  MyGrid.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "MyGrid.h"

@interface MyGrid()

@end

@implementation MyGrid

#define CELL_PADDING_FACTOR 0.08

//Row and Column Values Start From 0
-(CGRect)frameForCellInRow:(NSUInteger)row andColumn:(NSUInteger)column{
    CGFloat cellPadding = [self cellPadding];
    CGRect paddedRect;
    CGFloat cellWidth = [self cellWidth];
    CGFloat cellHeight = [self cellHeight];
    CGFloat paddedCellWidth = cellWidth - 2 * cellPadding;
    CGFloat paddedCellHeight = cellHeight - 2 * cellPadding;
    
    CGPoint cellOrigin;
    CGPoint paddedCellOrigin;
    CGSize paddedCellSize;
    
    cellOrigin.x = column * cellWidth;
    cellOrigin.y = row * cellHeight;
    paddedCellOrigin.x = cellOrigin.x + cellPadding;
    paddedCellOrigin.y = cellOrigin.y + cellPadding;
    
//    NSLog(@"Origin before pad: x: %f y: %f ", cellOrigin.x, cellOrigin.y);
//    NSLog(@"Origin after pad: x: %f y: %f ", paddedCellOrigin.x, paddedCellOrigin.y);
    
    paddedCellSize.width = paddedCellWidth;
    paddedCellSize.height = paddedCellHeight;
    
    paddedRect.origin = paddedCellOrigin;
    paddedRect.size = paddedCellSize;
    
    return paddedRect;
}

-(CGFloat)cellPadding{
    return [self cellWidth]*CELL_PADDING_FACTOR;
}

-(CGFloat)cellWidth{
    return (CGFloat)(self.size.width/self.numOfColumns);
}
-(CGFloat)cellHeight{
    return (CGFloat)(self.size.height/self.numOfRows);
}
@end
