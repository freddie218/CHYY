//
//  EventDetailViewController.m
//  chyy
//
//  Created by huan on 2/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Event.h"

@implementation EventDetailViewController

@synthesize event;
@synthesize members;

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
    
    if(![[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                     message:@"Can not be empty!"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.event) {
        event.name = self.nameTextField.text;
        event.eventmembers = self.participantSet;
    } else {
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        newEvent.name = self.nameTextField.text;
        newEvent.eventmembers = self.participantSet;        
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"can't save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
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

- (void) dismissKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.participantTextField resignFirstResponder];
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
    self.currentTextField = textField;
    
    if (textField == self.participantTextField ) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 300)];
        picker.dataSource = self;
        picker.delegate = self;
        textField.inputView = picker;
    }
    
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
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *memberResult = [[NSFetchRequest alloc] initWithEntityName:@"Member"];
    self.members = [[context executeFetchRequest:memberResult error:nil] mutableCopy];
    
    if (self.event) {
        [self.nameTextField setText:event.name];
        self.participantSet = (NSMutableSet *)self.event.eventmembers;
        [self.participantTextField setText:[[self.participantSet allObjects] componentsJoinedByString:@","]];
    } else {
        self.participantSet = [[NSMutableSet alloc] initWithCapacity:self.members.count];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [self.participantSet addObject:[members objectAtIndex:row]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.participantSet.count + 1;
    return members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *memberImageView = (UIImageView *)[cell viewWithTag:100];
    memberImageView.image = [UIImage imageWithData:[[members objectAtIndex:indexPath.row] valueForKey:@"avatar"]];
    
    UILabel *memberName = (UILabel *)[cell viewWithTag:101];
    memberName.text = [[members objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
}


@end
