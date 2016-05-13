//
//  NoteViewController.h
//  Notes
//
//  Created by Mac on 12.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate <NSObject>

- (void)textViewNote:(NSString *)text;

@end

@interface NoteViewController : UIViewController

@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) id <NoteViewControllerDelegate> delegate;

- (void)transitionText:(NSString *)text;

@end
