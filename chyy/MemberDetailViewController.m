//
//  MemberDetailViewController.m
//  chyy
//
//  Created by huan on 6/14/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import "MemberDetailViewController.h"

@interface MemberDetailViewController ()

@end

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.member) {
        [self.member setValue:self.nameTextField.text forKey:@"name"];
        [self.member setValue:self.sexTextField.text forKey:@"sex"];
        [self.member setValue:self.idTextField.text forKey:@"id"];
    } else {
        NSManagedObject *newMember = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        [newMember setValue:self.nameTextField.text forKey:@"name"];
        [newMember setValue:self.sexTextField.text forKey:@"sex"];
        [newMember setValue:self.idTextField.text forKey:@"id"];
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
    
    if (self.member) {
        [self.nameTextField setText:[self.member valueForKey:@"name"]];
        [self.sexTextField setText:[self.member valueForKey:@"sex"]];
        [self.idTextField setText:[self.member valueForKey:@"id"]];
    }
}

- (void) dismissKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
    [self.idTextField resignFirstResponder];
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
