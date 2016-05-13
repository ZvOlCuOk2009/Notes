//
//  NoteViewController.m
//  Notes
//
//  Created by Mac on 12.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "NoteViewController.h"
#import "TSMainTableViewController.h"

#import "TSDataManager.h"

@interface NoteViewController ()

//@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSString *currentData;
@property (strong, nonatomic) TSNote *note;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote:)];
    
    NSArray *buttons = @[deleteItem, saveItem];
    self.navigationItem.rightBarButtonItems = buttons;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"dd.MM.yyyy HH:mm";
    self.currentData = [dateFormater stringFromDate:[NSDate date]];
    
    self.dataLabel.text = self.data;
    self.contentTextView.text = self.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSManagedObjectContext

-(NSManagedObjectContext *) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[TSDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)saveNote:(UIBarButtonItem *)item
{
    self.note = [NSEntityDescription insertNewObjectForEntityForName:@"TSNote"
                                              inManagedObjectContext:self.managedObjectContext];
    self.note.data = self.currentData;
    self.note.content = self.contentTextView.text;
    [self.managedObjectContext save:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteNote:(UIBarButtonItem *)item
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"deleted");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}


@end
