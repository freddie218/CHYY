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
@synthesize event;

@synthesize members;
@synthesize categories;
@synthesize subCategories;

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
    [self.currentTextField resignFirstResponder];
    
    if(![[self.payerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] ||
       ![[self.amountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] ||
       ![[self.reasonTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] ||
       ![[self.timeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]
       ) {
        //string is all whitespace
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                     message:@"All field can not be empty!"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"China/Beijing"]];
    
    if (self.expense) {
//        expense.payer = self.payerTextField.text;
        expense.amount = [NSNumber numberWithDouble:[self.amountTextField.text doubleValue]];
        expense.reason = self.reasonTextField.text;
        expense.location = self.locationTextField.text;
//        expense.participant = self.participantTextField.text;
        expense.time = [df dateFromString: self.timeTextField.text];
        expense.memo = self.memoTextField.text;
        
        expense.participantmembers = self.participantSet;
        expense.payermember = self.selectedMember;

    } else {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
//        newExpense.payer = self.payerTextField.text;
        newExpense.amount = [NSNumber numberWithDouble:[self.amountTextField.text doubleValue]];
        newExpense.reason = self.reasonTextField.text;
        newExpense.location = self.locationTextField.text;
//        newExpense.participant = self.participantTextField.text;
        newExpense.time = [df dateFromString: self.timeTextField.text];
        newExpense.memo = self.memoTextField.text;
        newExpense.status = @"active";
        
        newExpense.payermember = self.selectedMember;
        newExpense.participantmembers = self.participantSet;
        
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
    [df setDateFormat:@"yyyy年M月d日 HH:mm"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    
    self.members = [[self.event.eventmembers allObjects] mutableCopy];

    if (self.expense) {
        self.selectedMember = self.expense.payermember;
        self.payerTextField.text = self.expense.payermember.name;
        self.participantSet = (NSMutableSet *)self.expense.participantmembers;
        
        self.amountTextField.text = [NSString stringWithFormat:@"%.02f", [[self.expense valueForKey:@"amount"] doubleValue]];
        self.locationTextField.text = [self.expense valueForKey:@"location"];
        self.timeTextField.text = [df stringFromDate:[self.expense valueForKey:@"time"]];
        self.reasonTextField.text = [self.expense valueForKey:@"reason"];
        self.memoTextField.text = [self.expense valueForKey:@"memo"];
        
    } else{
        self.timeTextField.text = [df stringFromDate:[NSDate date]];
        self.participantSet = [[NSMutableSet alloc] initWithCapacity:self.members.count];
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *categoryResult = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    categoryResult.predicate = [NSPredicate predicateWithFormat:@"parentcategory == %@", nil];
    self.categories = [[context executeFetchRequest:categoryResult error:nil] mutableCopy];
    
    if (categories.count > 0) {
        NSFetchRequest *subCategoryResult = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
        subCategoryResult.predicate = [NSPredicate predicateWithFormat:@"parentcategory == %@", [categories objectAtIndex:0]];
        self.subCategories = [[[self managedObjectContext] executeFetchRequest:subCategoryResult error:nil] mutableCopy];
    }

}

- (void) dismissKeyboard
{
    [self.payerTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    [self.reasonTextField resignFirstResponder];
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
    
    if (textField == self.payerTextField || textField == self.reasonTextField ) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 300)];
        // I think here the datesource and delegate should be assigned to another controller rather than self. [SUX-16]
        picker.dataSource = self;
        picker.delegate = self;
        textField.inputView = picker;
    } else if (textField == self.timeTextField) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年M月d日 HH:mm"];
        [df setTimeZone:[NSTimeZone defaultTimeZone]];
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        if (textField.text.length > 0) {
            [picker setDate: [df dateFromString: textField.text]];
        }
        else {
            [picker setDate:[NSDate date]];
        }
        
        [picker addTarget:self action:@selector(updateTimeTextField:) forControlEvents:UIControlEventValueChanged];
        textField.inputView = picker;
    }
    
}

- (void)updateTimeTextField: (id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年M月d日 HH:mm"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    UIDatePicker *picker = (UIDatePicker *)self.timeTextField.inputView;
    self.timeTextField.text = [df stringFromDate: picker.date];
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
        textField == self.timeTextField) {
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.currentTextField == self.reasonTextField) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        if (self.currentTextField == self.reasonTextField) {
            return categories.count;
        } else {
            return members.count;
        }

    } else {
        return subCategories.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (self.currentTextField == self.reasonTextField) {
            return [[categories objectAtIndex:row] valueForKey:@"name"];
        } else {
            return [[members objectAtIndex:row] valueForKey:@"name"];
        }
        
    } else {
        
        return [[subCategories objectAtIndex:row] valueForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *currentSelectStr;
    
    if(component == 0)
    {
        
        if (self.currentTextField == self.payerTextField) {
//            currentSelectStr = [[members objectAtIndex:row] valueForKey:@"name"];
            self.selectedMember = [members objectAtIndex:row];
            currentSelectStr = self.selectedMember.name;
            
        } else if (self.currentTextField == self.reasonTextField) {
            
            NSFetchRequest *subCategoryResult = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
            subCategoryResult.predicate = [NSPredicate predicateWithFormat:@"parentcategory == %@", [categories objectAtIndex:row]];
            self.subCategories = [[[self managedObjectContext] executeFetchRequest:subCategoryResult error:nil] mutableCopy];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            
        }
        
    } else {
        currentSelectStr = [[subCategories objectAtIndex:row] valueForKey:@"name"];
    }
    
    [self.currentTextField setText:currentSelectStr];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.participantSet.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ExpenseCollectionViewCell";
    ExpenseCollectionViewCell *cell = (ExpenseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == self.participantSet.count) {
        cell.avatarImageView.image = [UIImage imageNamed:@"add_member.png"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performSegue)];
        cell.avatarImageView.userInteractionEnabled = YES;
        [cell.avatarImageView addGestureRecognizer:tap];
        
        cell.nameLabel.text = @"";
        
    } else {
        Member *member = [[self.participantSet allObjects] objectAtIndex:indexPath.row];
        
        if ([member.avatar length] <= 0) {
            if ([member.sex isEqualToString:@"女"]) {
                cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_female.jpg"];
            } else {
                cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_male.jpg"];
            }
        } else {
            cell.avatarImageView.image = [UIImage imageWithData:member.avatar];
        }
        
        cell.avatarImageView.userInteractionEnabled = NO;
        cell.nameLabel.text = [[[self.participantSet allObjects] objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)performSegue
{
    [self performSegueWithIdentifier:@"ExpenseMemberCollectionSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ExpenseMemberCollectionSegue"]) {
        MemberCollectionViewController *memberCollectionViewController = segue.destinationViewController;
        memberCollectionViewController.availableMembers = self.members;
        memberCollectionViewController.participantSet = self.participantSet;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [(UICollectionView *)[self.view viewWithTag:252] reloadData];
}

@end
