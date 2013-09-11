//
//  GCPersonalRecipeDetailViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/21/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCPersonalRecipeDetailViewController.h"

@interface GCPersonalRecipeDetailViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *ingredientsView;
@property (strong, nonatomic) IBOutlet UITextView *instructionsView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *ingredientsList;

@property (strong, nonatomic) NSString *ti;
@property (strong, nonatomic) NSString *ing;
@property (strong, nonatomic) NSString *ins;

@end

@implementation GCPersonalRecipeDetailViewController

@synthesize navBar;
@synthesize titleLabel;
@synthesize ingredientsView;
@synthesize instructionsView;
@synthesize scrollView;
@synthesize table;

@synthesize ingredientsList;

@synthesize ti;
@synthesize ing;
@synthesize ins;

- (void)setRecipeTitle:(NSString *)t withIngredients:(NSString *)i withInstructions:(NSString *)n{
    ti = t;
    ing = i;
    ins = n;
    [self setIngredientsList:[[i componentsSeparatedByString:@", "] copy]];
}

//determine screen size of device and show/hide the appropriate info button
-(void)determineScreenSizeAndDisplayAppropriateButtons{
    if ([UIScreen mainScreen].bounds.size.height < 568){
        [instructionsView setFrame:CGRectMake(20.0, 264.0, 280.0, 176.0)];
    }
    else{
        [instructionsView setFrame:CGRectMake(20.0, 264.0, 280.0, 265.0)];
    }
}

- (IBAction)xPressed:(UIBarButtonItem *)sender {
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.table setAllowsMultipleSelection:YES];
//    [self.table setAllowsMultipleSelectionDuringEditing:YES];
//    [self.table setEditing:YES animated:YES];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.navBar topItem].title = ti;
    [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Hoefler Text" size:21.0], UITextAttributeFont, nil]];
//    [titleLabel setText:ti];
    [ingredientsView setText:ing];
    [instructionsView setText:ins];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ingredientsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [ingredientsList objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] alpha] == 1.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [[tableView cellForRowAtIndexPath:indexPath] setAlpha:0.4];
        [UIView commitAnimations];
    }
    else if([[tableView cellForRowAtIndexPath:indexPath] alpha] == 0.4){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [[tableView cellForRowAtIndexPath:indexPath] setAlpha:1.0];
        [UIView commitAnimations];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
//        [ingredientsList removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}
*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.0];
//    [[tableView cellForRowAtIndexPath:indexPath] setAlpha:1.0];
//    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
