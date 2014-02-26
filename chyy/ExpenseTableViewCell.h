//
//  ExpenseTableViewCell.h
//  chyy
//
//  Created by huan on 2/26/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *participantsLabel;
@property (nonatomic, weak) IBOutlet UILabel *expenseLabel;

@end
