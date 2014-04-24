//
//  ReportViewController.m
//  chyy
//
//  Created by huan on 2/23/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"

@implementation ReportViewController

@synthesize event;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.reports = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *result = [[NSFetchRequest alloc] initWithEntityName:@"Expense"];
    result.predicate = [NSPredicate predicateWithFormat:@"(expensetoevent = %@) AND (status = %@)", event, @"active"];
    
    self.expenses = [[context executeFetchRequest:result error:nil] mutableCopy];
    
    for (id expense in self.expenses)
    {
        NSString *payer = [expense valueForKey:@"payer"];
        NSArray *participants = [[(NSString *)[expense valueForKey:@"participant"] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
        NSNumber *participantCount = [NSNumber numberWithInteger:[participants count]];
        NSNumber *amount = [expense valueForKey:@"amount"];
        
        double share = [amount doubleValue] / [participantCount doubleValue];
        
        //deal with payer dict
        NSMutableDictionary *payerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:payer, @"name", amount, @"total", [NSNumber numberWithDouble:0], @"balance", nil];
        
        // deal with participants
        bool payerIsPart = false;
        for (NSString *participant in participants) {
            if ([participant isEqualToString:payer]) {
                payerIsPart = TRUE;
                
                double balance = [amount doubleValue] - share + [[payerDict valueForKey:@"balance"] doubleValue];
                
                [payerDict setObject:[NSNumber numberWithDouble:balance] forKey:@"balance"];
                
            } else {
                
                NSArray *filtered = [self.reports filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name == %@)", participant]];
                
                if ([filtered count] == 0) {
                    NSMutableDictionary *partDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:participant, @"name", [NSNumber numberWithDouble:0], @"total", [NSNumber numberWithDouble:-share], @"balance", nil];

                    [self.reports addObject:partDict];
                    
                } else {
                    
                    NSMutableDictionary *partItem = [filtered objectAtIndex:0];
                    double currentBalance = [[partItem valueForKey:@"balance"] doubleValue] - share;
                    NSNumber *updatedBalance = [NSNumber numberWithDouble:currentBalance];
                    
                    [partItem setObject:updatedBalance forKey:@"balance"];
                    
                }
            }
        }
        
        if (!payerIsPart) {
            double balance = [amount doubleValue] + [[payerDict valueForKey:@"balance"] doubleValue];
            [payerDict setObject:[NSNumber numberWithDouble:balance] forKey:@"balance"];
        }
        
        NSArray *filtered = [self.reports filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name == %@)", payer]];
        if ([filtered count] == 0) {
            [self.reports addObject:payerDict];
            
        } else {
            NSMutableDictionary *payerItem = [filtered objectAtIndex:0];
            
            double currentTotal = [[payerItem valueForKey:@"total"] doubleValue] + [amount doubleValue];
            double currentBalance = [[payerItem valueForKey:@"balance"] doubleValue] + [amount doubleValue] - share;
            
            [payerItem setObject:[NSNumber numberWithDouble:currentTotal] forKey:@"total"];
            [payerItem setObject:[NSNumber numberWithDouble:currentBalance] forKey:@"balance"];            
            
        }
        
    }
    
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
//    NSLog(@"reports is:  %@", self.reports);
    

    // Calculating the final report now
    // step 1. create two array with positive and negative balance.
    NSMutableArray *positiveBlanceItems = [[NSMutableArray alloc] init];
    NSMutableArray *negativeBlanceItems = [[NSMutableArray alloc] init];

    for (NSMutableDictionary *balanceItemDict in self.reports)
    {
        if ([[balanceItemDict valueForKey:@"balance"] doubleValue] >= 0)
        {
            [positiveBlanceItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[balanceItemDict valueForKey:@"name"], @"name", [balanceItemDict valueForKey:@"balance"], @"balance", nil]];
        } else {
            [negativeBlanceItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[balanceItemDict valueForKey:@"name"], @"name", [balanceItemDict valueForKey:@"balance"], @"balance", nil]];
        }
    }

    // step 2. order these two item array
    NSSortDescriptor *balanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"balance" ascending:NO];
    positiveBlanceItems = (NSMutableArray *)[positiveBlanceItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:balanceDescriptor,nil]];
    negativeBlanceItems = (NSMutableArray *)[negativeBlanceItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:balanceDescriptor,nil]];

    // step 3. loop through two balance items, to achieve the final report
    self.solvedReports = [[NSMutableArray alloc] init];

    for (NSMutableDictionary *posiBalItemDict in positiveBlanceItems)
    {
        for (NSMutableDictionary *negaBalItemDict in negativeBlanceItems)
        {
            double posiDouble = [[posiBalItemDict valueForKey:@"balance"] doubleValue];
            double negaDouble = [[negaBalItemDict valueForKey:@"balance"] doubleValue]; 
            if (negaDouble == 0 || posiDouble == 0) continue;

            if (posiDouble + negaDouble >= 0)
            {
                [self.solvedReports addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[posiBalItemDict valueForKey:@"name"], @"to", [negaBalItemDict valueForKey:@"name"], @"from", [NSNumber numberWithDouble:fabs(negaDouble)], @"balance", nil]];
                [posiBalItemDict setObject:[NSNumber numberWithDouble:(posiDouble + negaDouble)] forKey:@"balance"];
                [negaBalItemDict setObject:[NSNumber numberWithDouble:0] forKey:@"balance"];
            } else {
                [self.solvedReports addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[posiBalItemDict valueForKey:@"name"], @"to", [negaBalItemDict valueForKey:@"name"], @"from", [NSNumber numberWithDouble:posiDouble], @"balance", nil]];
                [posiBalItemDict setObject:[NSNumber numberWithDouble:0] forKey:@"balance"];
                [negaBalItemDict setObject:[NSNumber numberWithDouble:(posiDouble + negaDouble)] forKey:@"balance"];
            }

            if ([[posiBalItemDict valueForKey:@"balance"] doubleValue] == 0) break;
        }

    }      

//   NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
//   NSLog(@"final reports is:  %@", self.solvedReports);

    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *cellId = @"HeaderCell";
    if (section == 1) {
        cellId = @"ExpenseReportHeaderCell";
    }
    
    return [tableView dequeueReusableCellWithIdentifier:cellId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.reports.count;
    } else {
        return self.solvedReports.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ReportCell" forIndexPath:indexPath];
        
        NSManagedObject *report = [self.reports objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [report valueForKey:@"name"]];
        cell.totalLabel.text = [NSString stringWithFormat:@"%.02f", [[report valueForKey:@"total"] doubleValue]];
        cell.balanceLabel.text = [NSString stringWithFormat:@"%.02f", [[report valueForKey:@"balance"] doubleValue]];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *memberResult = [[NSFetchRequest alloc] initWithEntityName:@"Member"];
        memberResult.predicate = [NSPredicate predicateWithFormat:@"name == %@", [report valueForKey:@"name"]];
        Member *member = [[context executeFetchRequest:memberResult error:nil] firstObject];
        
        if ([member.avatar length] <= 0) {
            if ([member.sex isEqualToString:@"女"]) {
                cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_female.jpg"];
            } else {
                cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_male.jpg"];
            }
        } else {
            cell.avatarImageView.image = [UIImage imageWithData:member.avatar];
        }
        
        return cell;
        
    } else {
        UITableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpenseReportDetailCell" forIndexPath:indexPath];
        
        NSManagedObject *solvedReport = [self.solvedReports objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 支付给 %@ %.02f 元", [solvedReport valueForKey:@"from"], [solvedReport valueForKey:@"to"], [[solvedReport valueForKey:@"balance"] doubleValue]];
        
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (IBAction)resolve:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (Expense *expense in self.expenses) {
        expense.status = @"settled";
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"can't save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

@end
