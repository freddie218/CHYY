//
//  MemberCollectionViewController.h
//  chyy
//
//  Created by Huan Wang on 4/22/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
#import "MemberCollectionViewCell.h"

@interface MemberCollectionViewController : UICollectionViewController

@property (strong) NSMutableArray *availableMembers;
@property (strong, nonatomic) NSMutableSet *participantSet;

- (IBAction)save:(id)sender;

@end
