//
//  ExpenseDetailViewController.m
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import "ExpenseDetailViewController.h"

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController

- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
    [newExpense setValue:self.payerTextField.text forKey:@"payer"];
    [newExpense setValue:self.amountTextField.text forKey:@"amount"];
    [newExpense setValue:self.reasonTextField.text forKey:@"reason"];
    [newExpense setValue:self.locationTextField.text forKey:@"location"];
    [newExpense setValue:self.participantTextField.text forKey:@"participant"];
    [newExpense setValue:self.timeTextField.text forKey:@"time"];
    [newExpense setValue:self.memoTextField.text forKey:@"memo"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"can't save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
