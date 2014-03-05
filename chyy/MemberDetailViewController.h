//
//  MemberDetailViewController.h
//  chyy
//
//  Created by huan on 6/14/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong) NSManagedObject *member;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *sexTextField;
@property (strong, nonatomic) IBOutlet UITextField *idTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
