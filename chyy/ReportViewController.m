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
    
    for (id expense in self.expenses) {
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
    
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reports.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReportCell";
    ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
