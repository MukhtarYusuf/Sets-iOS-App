//
//  HighScore+CoreDataProperties.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 10/6/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "HighScore+CoreDataProperties.h"

@implementation HighScore (CoreDataProperties)

+ (NSFetchRequest<HighScore *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HighScore"];
}

+ (void)insertHighScoreWithRank:(int)rank name:(NSString *)name value:(long)value totalTime:(long)totalTime date:(NSDate *)date andContext:(nonnull NSManagedObjectContext *)context{
    
    HighScore *highScore = [NSEntityDescription insertNewObjectForEntityForName:@"HighScore" inManagedObjectContext:context];

    highScore.rank = rank;
    highScore.name = name;
    highScore.value = value;
    highScore.totalTime = totalTime;
    highScore.date = date;
}


@dynamic name;
@dynamic rank;
@dynamic value;
@dynamic totalTime;
@dynamic date;

@end
