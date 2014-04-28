//
//  ExpenseCollectionViewCell.h
//  chyy
//
//  Created by Huan Wang on 4/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
