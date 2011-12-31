//
//  CVMasterViewController.m
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import "CVMasterViewController.h"
#import "CVDetailViewController.h"
#import "CVAddForm.h"

@interface CVMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

NSMutableArray *onFunctions;

@implementation CVMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

@synthesize shouldAddEq;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Functions", @"Master");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayForm)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];    
    onFunctions = [[NSMutableArray alloc] initWithCapacity:[sectionInfo numberOfObjects]];
    for( int i = 0; i < (int)[sectionInfo numberOfObjects]; i++ ) {
        [onFunctions addObject:@"NO"];  //Set default to NO
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)pushFunctionAtIndex: (NSIndexPath *)indexPath {
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.currentFunction = [selectedObject valueForKey:@"function"];
    self.detailViewController.currentxFunction = [selectedObject valueForKey:@"xfunction"];
    self.detailViewController.isPolar = [selectedObject valueForKey:@"polar"];
    self.detailViewController.window = [selectedObject valueForKey:@"window"];
    
    NSString *window = [selectedObject valueForKey:@"window"];
    NSArray *parts = [window componentsSeparatedByString:@", "];
    NSString *xStart = [parts objectAtIndex:0];
    NSString *xEnd = [parts objectAtIndex:1];
    NSString *fInput = [NSString stringWithFormat:@"(%@-(%@))", xEnd, xStart];
    
    self.detailViewController.functionInput = fInput;
    
    [self.detailViewController pushFunction:[selectedObject valueForKey:@"function"] polar:[selectedObject valueForKey:@"polar"] window:[selectedObject valueForKey:@"window"] inColor:[selectedObject valueForKey:@"color"] andXFunction:[selectedObject valueForKey:@"xfunction"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    if( indexPath != nil ) {
        NSString *item = [onFunctions objectAtIndex:[indexPath row]];
        if( [item isEqualToString:@"NO"] ) {
            //Toggle on
            [onFunctions replaceObjectAtIndex:[indexPath row] withObject:@"YES"];
        } else {
            //Toggle off
            [onFunctions replaceObjectAtIndex:[indexPath row] withObject:@"NO"];
        }
        [tableView reloadData];      
        
        //Clear graph
        [self.detailViewController clearGraph];
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];    
    for( int i = (int)[sectionInfo numberOfObjects]-1; i >= 0; i-- ) {
        NSString *item = [onFunctions objectAtIndex:i];
        if( [item isEqualToString:@"YES"] )
            [self pushFunctionAtIndex:[NSIndexPath indexPathForRow:i inSection:0]];
    }

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (NSString *)hexToColor: (NSString *)hex {
    if( [hex isEqualToString:@"#ff0000"] )
        return @"Red";
    if( [hex isEqualToString:@"#ff7700"] )
        return @"Orange";
    if( [hex isEqualToString:@"#ffff00"] )
        return @"Yellow";
    if( [hex isEqualToString:@"#00ff00"] )
        return @"Green";
    if( [hex isEqualToString:@"#0000ff"] )
        return @"Blue";
    if( [hex isEqualToString:@"#7700ff"] )
        return @"Indigo";
    if( [hex isEqualToString:@"#ff00ff"] )
        return @"Violet";
    return @"Red";
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Get array of rows
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *fText = [[managedObject valueForKey:@"function"] description];
    if( [[[managedObject valueForKey:@"polar"] description] isEqualToString:@"Polar"] )
        fText = [fText stringByReplacingOccurrencesOfString:@"x" withString:@"θ"];
    if( [[[managedObject valueForKey:@"xfunction"] description] isEqualToString:@""] ) {
        cell.textLabel.text = fText;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"[%@, %@]", [[managedObject valueForKey:@"xfunction"] description], fText];
    }
    cell.detailTextLabel.text = [[[managedObject valueForKey:@"polar"] description] stringByAppendingFormat:@" - %@", [self hexToColor:[[managedObject valueForKey:@"color"] description]]];

    NSString *item = [onFunctions objectAtIndex:[indexPath row]];
    if( [item isEqualToString:@"NO"] ) {
        //if its turned off
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        //if its turned on
        cell.accessoryType = UITableViewCellAccessoryCheckmark;        
    }
}

- (void)dismissContinue: (NSDictionary *)values {
    //Handle all of the input values
    
    NSLog(@"dismiss");
    [self dismissModalViewControllerAnimated:YES];
    //Will include parameter for values
    [self insertNewObject: values];
}
- (void)dismissStop {
    NSLog(@"dismiss");
    [self dismissModalViewControllerAnimated:YES];    
    //Don't insert Object
}

- (void)displayForm {
    CVAddForm *cvaf = [[CVAddForm alloc] initWithNibName:@"CVAddView" bundle:nil];
    
    cvaf.delegate = self;
    cvaf.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:cvaf animated:YES];
}

- (void)insertNewObject: (NSDictionary *)input
{    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    //Keys:
    //Polar
    //Function
    //Color (#e3e3e3)
    //Window [NSData]
    NSString *errString;
    
    NSLog(@"Input window: %@", [input objectForKey:@"Window"]);
    
    NSArray *window = [input valueForKey:@"Window"];
    NSString *implode = [window componentsJoinedByString:@", "];
    //NSData *windowData = [NSPropertyListSerialization dataFromPropertyList:window format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errString];
    
    //Push all of the values
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:[input valueForKey:@"Polar"] forKey:@"Polar"];
    [newManagedObject setValue:[input valueForKey:@"Function"] forKey:@"Function"];
    [newManagedObject setValue:[input valueForKey:@"Color"] forKey:@"Color"];
    [newManagedObject setValue:implode forKey:@"Window"];
    [newManagedObject setValue:[input valueForKey:@"xFunction"] forKey:@"xfunction"];
    [newManagedObject setValue:@"On" forKey:@"On"];
    
    if( [@"On" isEqualToString:@"On"] ) {
        [self.detailViewController pushFunction:[input valueForKey:@"Function"] polar:[input valueForKey:@"Polar"] window:implode inColor:[input valueForKey:@"Color"] andXFunction:[input valueForKey:@"xFunction"]];
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSMutableArray *onFunctionsTemp = [[NSMutableArray alloc] initWithCapacity:[sectionInfo numberOfObjects]+1];
    [onFunctionsTemp addObject:@"YES"];
    for( int i = 0; i < (int)[sectionInfo numberOfObjects]; i++ ) {
        [onFunctionsTemp addObject:[onFunctions objectAtIndex:i]];
    }    
    
    onFunctions = onFunctionsTemp;
    [self.tableView reloadData];
    
    // Save the context.ef
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end



















