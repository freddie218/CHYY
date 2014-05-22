//
//  CategoryDetailViewController.h
//  chyy
//
//  Created by huan on 3/8/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoryDetailViewController : UIViewController <UITextFieldDelegate, UIBarPositioningDelegate>

@property (strong) Category *category;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
