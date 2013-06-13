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

@synthesize expense;

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
    
    if (self.expense) {
        [self.expense setValue:self.payerTextField.text forKey:@"payer"];
        [self.expense setValue:self.amountTextField.text forKey:@"amount"];
        [self.expense setValue:self.reasonTextField.text forKey:@"reason"];
        [self.expense setValue:self.locationTextField.text forKey:@"location"];
        [self.expense setValue:self.participantTextField.text forKey:@"participant"];
        [self.expense setValue:self.timeTextField.text forKey:@"time"];
        [self.expense setValue:self.memoTextField.text forKey:@"memo"];

    } else {
        NSManagedObject *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
        [newExpense setValue:self.payerTextField.text forKey:@"payer"];
        [newExpense setValue:self.amountTextField.text forKey:@"amount"];
        [newExpense setValue:self.reasonTextField.text forKey:@"reason"];
        [newExpense setValue:self.locationTextField.text forKey:@"location"];
        [newExpense setValue:self.participantTextField.text forKey:@"participant"];
        [newExpense setValue:self.timeTextField.text forKey:@"time"];
        [newExpense setValue:self.memoTextField.text forKey:@"memo"];
    }

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    if (self.expense) {
        [self.payerTextField setText:[self.expense valueForKey:@"payer"]];
        [self.amountTextField setText:[self.expense valueForKey:@"amount"]];
        [self.locationTextField setText:[self.expense valueForKey:@"location"]];
        [self.timeTextField setText:[self.expense valueForKey:@"time"]];
        [self.reasonTextField setText:[self.expense valueForKey:@"reason"]];
        [self.participantTextField setText:[self.expense valueForKey:@"participant"]];
        [self.memoTextField setText:[self.expense valueForKey:@"memo"]];
    }
}

- (void) dismissKeyboard
{
    [self.payerTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    [self.reasonTextField resignFirstResponder];
    [self.participantTextField resignFirstResponder];
    [self.memoTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
