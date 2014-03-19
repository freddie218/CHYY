//
//  ExpenseViewController.m
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import "ExpenseViewController.h"
#import "ExpenseDetailViewController.h"
#import "ExpenseTableViewCell.h"

@implementation ExpenseViewController

@synthesize event;

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
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *result = [[NSFetchRequest alloc] initWithEntityName:@"Expense"];
    result.predicate = [NSPredicate predicateWithFormat:@"(expensetoevent = %@) AND (status = %@)", event, @"active"];
    self.expenses = [[context executeFetchRequest:result error:nil] mutableCopy];
    
    result.predicate = [NSPredicate predicateWithFormat:@"(expensetoevent = %@) AND (status = %@)", event, @"settled"];
    self.settledExpenses = [[context executeFetchRequest:result error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 30.0 : 90.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *cellId = @"ExpenseHeaderCell";
    if (section == 1) {
        cellId = @"SettledExpenseCell";
    }
    
    return [tableView dequeueReusableCellWithIdentifier:cellId];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.expenses.count;
    } else {
        return self.settledExpenses.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExpenseCell";
    ExpenseTableViewCell *cell = (ExpenseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Expense *expense;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    if (indexPath.section == 0) {
        expense = [[self.expenses sortedArrayUsingDescriptors:sortDescriptors] objectAtIndex:indexPath.row];
    } else {
        expense = [[self.settledExpenses sortedArrayUsingDescriptors:sortDescriptors] objectAtIndex:indexPath.row];
    }
    
    cell.payerLabel.text = [NSString stringWithFormat:@"%@", expense.payer];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@", expense.reason];
    cell.memoLabel.text = [NSString stringWithFormat:@"%@", expense.memo];
    cell.participantsLabel.text = [NSString stringWithFormat:@"%@", expense.participant];
    cell.participantsCountLabel.text = [NSString stringWithFormat:@"(共%lu人)", (unsigned long)[[expense.participant componentsSeparatedByString:@","] count]];
    cell.expenseLabel.text = [NSString stringWithFormat:@"%.02f", [expense.amount doubleValue]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:expense.time];
    NSInteger day = [components day];
    NSInteger month = [components month];
    cell.dayLabel.text = [NSString stringWithFormat:@"%02ld", (long)day];
    cell.monthLabel.text = [NSString stringWithFormat:@"%ld月", (long)month];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.expenses objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.expenses removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self.tableView indexPathForSelectedRow].section == 1) {
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    ExpenseDetailViewController *detailViewCon = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"UpdateExpense"]) {
        Expense *selectedExpense = [self.expenses objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        detailViewCon.expense = selectedExpense;
    }
    
    detailViewCon.event = self.event;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
