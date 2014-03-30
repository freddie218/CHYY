//
//  ReportTableViewCell.m
//  chyy
//
//  Created by huan on 2/23/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "ReportTableViewCell.h"

@implementation ReportTableViewCell

@synthesize nameLabel;
@synthesize totalLabel;
@synthesize balanceLabel;
@synthesize avatarImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
