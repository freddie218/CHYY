//
//  ExpenseTableViewCell.h
//  chyy
//
//  Created by huan on 2/26/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *payerLabel;
@property (nonatomic, weak) IBOutlet UILabel *participantsLabel;
@property (nonatomic, weak) IBOutlet UILabel *participantsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *expenseLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *memoLabel;

@end
