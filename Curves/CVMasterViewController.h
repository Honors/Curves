//
//  CVMasterViewController.h
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVDetailViewController;

#import <CoreData/CoreData.h>

@interface CVMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPageViewControllerDelegate>

@property (strong, nonatomic) CVDetailViewController *detailViewController;
@property (retain, nonatomic) NSNumber *shouldAddEq;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)dismissContinue: (NSDictionary *)values;
- (void)dismissStop;
- (void)displayForm;

//- (void)insertNewObject;
- (void)insertNewObject: (NSDictionary *)input;

@end
