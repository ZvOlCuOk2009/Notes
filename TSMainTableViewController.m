//
//  MainTableViewController.m
//  Notes
//
//  Created by Mac on 12.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMainTableViewController.h"
#import "TSTableViewCell.h"
#import "NoteViewController.h"

#import "TSContentViewController.h"
#import "TSNote.h"
#import "TSDataManager.h"
#import <CoreData/CoreData.h>

@interface TSMainTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TSNote *note;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TSMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:)];
    
    self.navigationItem.leftBarButtonItem = addItem;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *tintColor = [UIColor colorWithRed:221.0f/255.0f green:187.0f/255.0f blue:0.0f/255.0f alpha:1];
    self.navigationController.navigationBar.tintColor = tintColor;
}

///*************
/*
- (TSNote *)randomNote
{
    TSNote *note = [NSEntityDescription insertNewObjectForEntityForName:@"TSNote"
                                                 inManagedObjectContext:self.managedObjectContext];
    note.data = [NSString stringWithFormat:@"%d.05.16", arc4random_uniform(30)];
    note.content = [NSString stringWithFormat:@"Заметка номер - %d", arc4random_uniform(100)];
    [self.managedObjectContext save:nil];
    
    return note;
}

- (NSArray *)allNotes
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSNote"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    return result;
}

- (void)printNotes
{
    NSArray *notes = [self allNotes];
    for (TSNote *note in notes) {
        NSLog(@"%@ %@", note.data, note.content);
    }
}

- (void)deleteNotes
{
    NSArray *notes = [self allNotes];
    for (TSNote *note in notes) {
        [self.managedObjectContext deleteObject:note];
    }
    [self.managedObjectContext save:nil];
}
*/
///*************

#pragma mark - NSManagedObjectContext

-(NSManagedObjectContext *) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[TSDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (void)addNote:(UIBarButtonItem *)item
{
    NoteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteViewController"];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"dd.MM.yyyy HH:mm";
    controller.data = [dateFormater stringFromDate:[NSDate date]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSContentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSContentViewController"];
    self.note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.data = self.note.data;
    controller.content = self.note.content;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error deleting item in coredata %@",[error localizedDescription]);
        }
    }
    
    if (indexPath.row) {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    
    NSLog(@"indexPath row = %ld", indexPath.row);
    NSLog(@"deleted");
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"moveRowAtIndexPath");
}

- (void)configureCell:(TSTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    if ([note.content intValue] >= 3) {
//        NSLog(@"note.content - %ld", (long)[note.content intValue]);
//        [[note.content componentsSeparatedByString:@" "] objectAtIndex:2];
//    } else if ([note.content intValue] == 2) {
//        [[note.content componentsSeparatedByString:@" "] objectAtIndex:1];
//    } else if ([note.content intValue] == 1) {
//        [[note.content componentsSeparatedByString:@" "] objectAtIndex:0];
//    }
    cell.dataLabel.text = note.data;
    cell.contentLabel.text = note.content;
}

- (NSUInteger)wordCount
{
    NSInteger value = [self.note.data intValue];
    
    return value;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSNote" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptorData = [[NSSortDescriptor alloc] initWithKey:@"content" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptorData]];
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            return;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
