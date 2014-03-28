//
//  MemberDetailViewController.m
//  chyy
//
//  Created by huan on 6/14/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import "MemberDetailViewController.h"

@implementation MemberDetailViewController

@synthesize member;

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
    
    if(![[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        //string is all whitespace
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                     message:@"Name can not be empty!"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSLog(@"============== size: %d", self.avatarImageData.length);
    
    if (self.member) {
        self.member.name = self.nameTextField.text;
        self.member.sex = self.sexTextField.text;
        self.member.avatar = self.avatarImageData;
    } else {
        Member *newMember = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        newMember.name = self.nameTextField.text;
        newMember.sex = self.sexTextField.text;
        newMember.avatar = self.avatarImageData;
    }

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"can't save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField )
    {
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    
    if (textField == self.sexTextField ) {
        
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
    
    self.gendars = [NSArray arrayWithObjects:@"男", @"女", @"......", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    if (self.member) {
        self.nameTextField.text = self.member.name;
        self.sexTextField.text = self.member.sex;
        self.avatarImageView.image = [UIImage imageWithData:self.member.avatar];
    }
}

- (void) dismissKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.gendars.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.gendars objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.currentTextField setText:[self.gendars objectAtIndex:row]];
    
}

- (IBAction)addAvatar:(UITapGestureRecognizer *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *avatarImage = info[UIImagePickerControllerEditedImage];
    self.avatarImageView.image = avatarImage;
    self.avatarImageData = UIImageJPEGRepresentation(avatarImage, 0.9);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
