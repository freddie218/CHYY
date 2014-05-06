//
//  EventDetailViewController.h
//  chyy
//
//  Created by huan on 2/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "MemberCollectionViewController.h"
#import "EventCollectionViewCell.h"

@interface EventDetailViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong) Event *event;
@property (strong, nonatomic) NSMutableArray *members;
@property (strong, nonatomic) NSMutableSet *participantSet;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
