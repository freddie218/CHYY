//
//  EventDetailViewController.h
//  chyy
//
//  Created by huan on 2/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong) Event *event;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
