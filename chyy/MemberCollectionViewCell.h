//
//  MemberCollectionViewCell.h
//  chyy
//
//  Created by Huan Wang on 4/22/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
