//
//  EventDetailViewController.m
//  chyy
//
//  Created by huan on 2/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "EventDetailViewController.h"

@implementation EventDetailViewController

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.event) {
        [self.event setValue:self.nameTextField.text forKey:@"name"];
    } else {
        NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        NSManagedObjectID *moID = [newEvent objectID];
        NSString *taskUniqueStringKey = moID.URIRepresentation.absoluteString;
        
        [newEvent setValue:self.nameTextField.text forKey:@"name"];
        [newEvent setValue:taskUniqueStringKey forKey:@"id"];
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
    
    if (self.event) {
        [self.nameTextField setText:[self.event valueForKey:@"name"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
