//
//  HighScore+CoreDataProperties.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 10/6/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "HighScore+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HighScore (CoreDataProperties)

+ (NSFetchRequest<HighScore *> *)fetchRequest;
+ (void)insertHighScoreWithRank:(int)rank name:(NSString *)name value:(long)value totalTime:(long)totalTime date:(NSDate *)date andContext:(nonnull NSManagedObjectContext *)context;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t rank;
@property (nonatomic) int64_t value;
@property (nonatomic) int64_t totalTime;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
