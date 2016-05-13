//
//  TSContentViewController.m
//  Notes
//
//  Created by Mac on 13.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSContentViewController.h"
#import "TSMainTableViewController.h"
#import "TSDataManager.h"

@interface TSContentViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSString *currentData;
@property (strong, nonatomic) TSNote *note;

@end

@implementation TSContentViewController

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
    self.headerLabel.text = [[self.content componentsSeparatedByString:@" "] objectAtIndex:0];
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

#pragma mark - Actions

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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Вы хотите удалить"
                                                                             message:@"заметку?..."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Нет"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Да"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                          NSLog(@"deleted");
                                                      }];
    [alertController addAction:actionNo];
    [alertController addAction:actionYes];
    [self presentViewController:alertController animated:YES completion:^{ }];
}

@end
