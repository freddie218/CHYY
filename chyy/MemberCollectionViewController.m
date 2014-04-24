//
//  MemberCollectionViewController.m
//  chyy
//
//  Created by Huan Wang on 4/22/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import "MemberCollectionViewController.h"

@implementation MemberCollectionViewController

@synthesize availableMembers;

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
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return availableMembers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Member *member = [self.availableMembers objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"MemberCollectionCell";
    MemberCollectionViewCell *cell = (MemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.nameLabel.text = member.name;
    cell.avatarImageView.image = [UIImage imageWithData:member.avatar];
    
    if ([member.avatar length] <= 0) {
        if ([member.sex isEqualToString:@"女"]) {
            cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_female.jpg"];
        } else {
            cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar_male.jpg"];
        }
    } else {
        cell.avatarImageView.image = [UIImage imageWithData:member.avatar];
    }
    
    [cell.avatarImageView.layer setMasksToBounds:YES];
    [cell.avatarImageView.layer setCornerRadius:5.0f];
    
    // todo xc
    if (cell.selected) {
        
    }
    
    cell.selectedBackgroundView = [[UIImageView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *selectedRecipe = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
//    [selectedRecipes addObject:selectedRecipe];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *deSelectedRecipe = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
//    [selectedRecipes removeObject:deSelectedRecipe];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MemberCollectionHeaderView" forIndexPath:indexPath];
                
        reusableview = headerView;
    }
    
    return reusableview;
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    //TBD!!
}

@end
