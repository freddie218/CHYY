//
//  CategoryViewController.m
//  chyy
//
//  Created by huan on 3/7/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "CategoryViewController.h"

@implementation CategoryViewController

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
    NSFetchRequest *result = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    
    result.predicate = [NSPredicate predicateWithFormat:@"parentcategory == %@", nil];
    
    self.categories = [[context executeFetchRequest:result error:nil] mutableCopy];
    
    [self.tableView reloadData];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Category *category = [self.categories objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", category.name]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SubCategory"]) {
        SubCategoryViewController *subCategoryViewController = (SubCategoryViewController *)segue.destinationViewController;
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Category *category = [self.categories objectAtIndex:path.row];
        
        subCategoryViewController.parentCategory = category;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        Category *currentCategory = [self.categories objectAtIndex:indexPath.row];
        NSFetchRequest *result = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
        result.predicate = [NSPredicate predicateWithFormat:@"parentcategory = %@", currentCategory];
        NSArray *subCategories = [[context executeFetchRequest:result error:nil] mutableCopy];
        
        for (Category *category in subCategories) {
            [context deleteObject:category];
        }
        [context deleteObject:currentCategory];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.categories removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
