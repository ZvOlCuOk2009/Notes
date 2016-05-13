//
//  NoteViewController.m
//  Notes
//
//  Created by Mac on 12.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "NoteViewController.h"
#import "TSMainTableViewController.h"

@interface NoteViewController ()

//@property (strong, nonatomic) TSMainTableViewController *mainController;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote:)];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
    self.dataLabel.text = self.data;
    self.contentTextView.text = self.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transitionText:(NSString *)text
{
    [self.delegate textViewNote:self.contentTextView.text];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
//    self.mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTableViewController"];
//    self.mainController.textNote = self.contentTextView.text;
}

- (void)deleteNote:(UIBarButtonItem *)item
{
    NSLog(@"%@", self.contentTextView.text);
    
    NSLog(@"delete note");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
