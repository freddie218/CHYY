//
//  ExpenseDetailViewController.m
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import "ExpenseDetailViewController.h"

@implementation ExpenseDetailViewController

@synthesize expense;
@synthesize members;
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

- (IBAction)cancel:(id)sender
{
    self.currentTextField.text = @"cancelEditing";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    if (self.expense) {
        expense.payer = self.payerTextField.text;
        expense.amount = [NSNumber numberWithDouble:[self.amountTextField.text doubleValue]];
        expense.reason = self.reasonTextField.text;
        expense.location = self.locationTextField.text;
        expense.participant = self.participantTextField.text;
        expense.time = [df dateFromString: self.timeTextField.text];
        expense.memo = self.memoTextField.text;

    } else {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
        newExpense.payer = self.payerTextField.text;
        newExpense.amount = [NSNumber numberWithDouble:[self.amountTextField.text doubleValue]];
        newExpense.reason = self.reasonTextField.text;
        newExpense.location = self.locationTextField.text;
        newExpense.participant = self.participantTextField.text;
        newExpense.time = [df dateFromString: self.timeTextField.text];
        newExpense.memo = self.memoTextField.text;
        
        newExpense.expensetoevent = event;
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
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];

    if (self.expense) {
        [self.payerTextField setText:[self.expense valueForKey:@"payer"]];
        [self.amountTextField setText:[NSString stringWithFormat:@"%.02f", [[self.expense valueForKey:@"amount"] doubleValue]]];
        [self.locationTextField setText:[self.expense valueForKey:@"location"]];
        [self.timeTextField setText:[df stringFromDate:[self.expense valueForKey:@"time"]]];
        [self.reasonTextField setText:[self.expense valueForKey:@"reason"]];
        [self.participantTextField setText:[self.expense valueForKey:@"participant"]];
        [self.memoTextField setText:[self.expense valueForKey:@"memo"]];
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *memberResult = [[NSFetchRequest alloc] initWithEntityName:@"Member"];
    self.members = [[context executeFetchRequest:memberResult error:nil] mutableCopy];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y - 50);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    
    self.currentTextField = textField;
    
    if (textField == self.payerTextField || textField == self.participantTextField ) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 300)];
        // I think here the datesource and delegate should be assigned to another controller rather than self. [SUX-16]
        picker.dataSource = self;
        picker.delegate = self;
        textField.inputView = picker;
    } else if (textField == self.timeTextField) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        [picker setDate:[NSDate date]];
        [picker addTarget:self action:@selector(updateTimeTextField:) forControlEvents:UIControlEventValueChanged];
        textField.inputView = picker;
    }
    
}

- (void)updateTimeTextField: (id)sender
{
    UIDatePicker *picker = (UIDatePicker *)self.timeTextField.inputView;
    self.timeTextField.text = [NSString stringWithFormat:@"%@", picker.date];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.amountTextField) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.payerTextField ||
        textField == self.amountTextField ||
        textField == self.reasonTextField ||
        textField == self.timeTextField ||
        textField == self.participantTextField) {
        if(![[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            //string is all whitespace
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Entry Error"
                                                          message:@"Can not be empty!"
                                                         delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    return YES;
}

// ----------- Member Picker start ------------- [SUX-16]
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return members.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[members objectAtIndex:row] valueForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *currentSelectStr;
    
    if (self.currentTextField == self.payerTextField) {
        currentSelectStr = [[members objectAtIndex:row] valueForKey:@"name"];
    } else if (self.currentTextField == self.participantTextField) {
        
        NSMutableSet *participantSet = [NSMutableSet setWithObject:[[members objectAtIndex:row] valueForKey:@"name"]];
        if (![self.currentTextField.text isEqualToString:@""]) {
            [participantSet addObjectsFromArray:[self.currentTextField.text componentsSeparatedByString:@","]];
        }
        
        currentSelectStr = [[participantSet allObjects] componentsJoinedByString:@","];
    }
 
    [self.currentTextField setText:currentSelectStr];

}
// ----------- Member Picker end ------------- [SUX-16]

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
