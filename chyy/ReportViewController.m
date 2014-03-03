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
    result.predicate = [NSPredicate predicateWithFormat:@"expensetoevent = %@", event];
    
    self.expenses = [[context executeFetchRequest:result error:nil] mutableCopy];
    
    NSLog(@"===============================================");
    NSLog(@"expenses is:  %@", self.expenses);
    
    for (id expense in self.expenses) {
        NSString *payer = [expense valueForKey:@"payer"];
        NSArray *participants = [[(NSString *)[expense valueForKey:@"participant"] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
        NSNumber *participantCount = [NSNumber numberWithInteger:[participants count]];
        NSNumber *amount = [expense valueForKey:@"amount"];
        double share = [amount doubleValue] / [participantCount doubleValue];

        
        //deal with payer dict
        NSMutableDictionary *payerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:payer, @"name", amount, @"total", [NSNumber numberWithDouble:0], @"balance", nil];
    
        // deal with participants
        for (NSString *participant in participants) {
            if ([participant isEqualToString:payer]) {
                [payerDict setObject:[NSNumber numberWithDouble:share] forKey:@"balance"];
                
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
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    NSLog(@"reports is:  %@", self.reports);
    
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
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(50.0f/255.0f) green:(200.0f/255.0f) blue:(200.0f/255.0f) alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(50.0f/255.0f) green:(200.0f/255.0f) blue:(200.0f/255.0f) alpha:1.0f];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
