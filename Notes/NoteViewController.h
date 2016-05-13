//
//  NoteViewController.h
//  Notes
//
//  Created by Mac on 12.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNote.h"

@interface NoteViewController : UIViewController

@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end
