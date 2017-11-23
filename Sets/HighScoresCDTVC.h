//
//  HighScoresCDTVC.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 8/22/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HighScoreConstants.h"

@interface HighScoresCDTVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
