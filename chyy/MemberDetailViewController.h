//
//  MemberDetailViewController.h
//  chyy
//
//  Created by huan on 6/14/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface MemberDetailViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong) Member *member;
@property (strong, nonatomic) NSArray *gendars;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *sexTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
