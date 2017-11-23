//
//  HighScoresCDTVC.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 8/22/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "HighScoresCDTVC.h"
#import "HighScore+CoreDataProperties.h"
#import "HighScoreDetailsViewController.h"

@interface HighScoresCDTVC()
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@end

@implementation HighScoresCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifier = @"Show HS Detail";
    if([segue.identifier isEqualToString:identifier]){
        if([sender isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *cellSender = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cellSender];
            HighScore *hs = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            HighScoreDetailsViewController *hsdvc = (HighScoreDetailsViewController *)segue.destinationViewController;
            hsdvc.highScore = hs;
        }
    }
}

//--UITableView DataSource--
#pragma mark UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Score Cell";
    
    UITableViewCell *tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HighScore *highScore = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *rankLabel = [tableViewCell viewWithTag:1];
    UILabel *nameLabel = [tableViewCell viewWithTag:2];
    UILabel *valueLabel = [tableViewCell viewWithTag:3];
    
    rankLabel.text = [NSString stringWithFormat:@"%i", highScore.rank];
    nameLabel.text = highScore.name;
    
    NSString *valueString = [self.numberFormatter stringFromNumber:[NSNumber numberWithLongLong:highScore.value]];
    valueLabel.text = [NSString stringWithFormat:@"%@", valueString];
    
    return tableViewCell;
}

//--Getters and Setters
#pragma mark Getters and Setters
-(NSFetchedResultsController *)fetchedResultsController{
    if(!_fetchedResultsController && self.context){
        [self setUpFetchedResultsController];
    }
    return _fetchedResultsController;
}

-(void)setContext:(NSManagedObjectContext *)context{
    _context = context;
    if(_context){
        [self setUpFetchedResultsController];
    }
}

- (NSNumberFormatter *)numberFormatter{
    if(!_numberFormatter){
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    return _numberFormatter;
}

//--Setup Code--
#pragma mark Setup Code
-(void)setUpFetchedResultsController{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"HighScore"];
    fetchRequest.fetchLimit = MAX_HIGHSCORES;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank"
                                                                     ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)showNavBar{
    [self.navigationController setNavigationBarHidden:NO];
}

//--ViewController Life Cycle
#pragma mark ViewController Life Cycle
-(void)viewDidLoad{
    NSError *error;
    if(![self.fetchedResultsController performFetch:&error]){
        NSLog(@"An Error Occured: %@", error);
    }
    [self showNavBar];
}


@end

