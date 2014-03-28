//
//  MemberTableViewCell.h
//  chyy
//
//  Created by Huan Wang on 3/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *gendarLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
