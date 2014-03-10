//
//  SubCategoryDetailViewController.h
//  chyy
//
//  Created by huan on 3/10/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface SubCategoryDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong) Category *parentCategory;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
