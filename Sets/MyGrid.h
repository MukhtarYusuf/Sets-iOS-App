//
//  MyGrid.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyGrid : NSObject
@property (nonatomic) CGSize size;
@property (nonatomic) NSUInteger numOfRows;
@property (nonatomic) NSUInteger numOfColumns;

-(CGRect)frameForCellInRow:(NSUInteger)row andColumn:(NSUInteger)column;
-(CGFloat)cellWidth;
-(CGFloat)cellHeight;
@end
