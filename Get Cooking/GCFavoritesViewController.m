//
//  GCFavoritesViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/13/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCFavoritesViewController.h"
#import "GCFavoriteDetailViewController.h"
#import "GCPersonalRecipeDetailViewController.h"
#import "GCAppDelegate.h"
#import "Favorite.h"
#import "PersonalRecipe.h"

@interface GCFavoritesViewController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSString *selectedHtml;
@property (strong, nonatomic) NSString *selectedIngredients;
@property (strong, nonatomic) NSString *selectedInstructions;
@property (strong, nonatomic) NSString *selectedTitle;

@end

@implementation GCFavoritesViewController

@synthesize favoritesArray;
@synthesize managedObjectContext;
@synthesize navBar;
@synthesize selectedHtml;
@synthesize selectedIngredients;
@synthesize selectedInstructions;
@synthesize selectedTitle;

- (IBAction)addPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ShowRecipeComposeView" sender:self];
}

- (IBAction)xPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getRecipes{
    //Get the Managed Object Context
    GCAppDelegate *d = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = d.getContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        //handle the error
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Failed to load managed object context." delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }
    
    //Get the Favorites from the Managed Object Context
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //Sort the Favorites by title
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    //Fetch the PersonalRecipes
    NSFetchRequest *otherRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personalRecipe = [NSEntityDescription entityForName:@"PersonalRecipe" inManagedObjectContext:managedObjectContext];
    
    [otherRequest setEntity:personalRecipe];
    [otherRequest setSortDescriptors:sortDescriptors];
    
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not fetch your HTML recipes!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }
    
    NSMutableArray *personalRecipeFetchResults = [[managedObjectContext executeFetchRequest:otherRequest error:&error] mutableCopy];
    if (personalRecipeFetchResults == nil) {
        // Handle the error.
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not fetch your Personal recipes!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }
    
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    [allResults addObjectsFromArray:mutableFetchResults];
    [allResults addObjectsFromArray:personalRecipeFetchResults];
    //    [self setFavoritesArray:mutableFetchResults];
    [self setFavoritesArray:allResults];
    //    [favoritesArray addObjectsFromArray:mutableFetchResults];
    //    [favoritesArray addObjectsFromArray:personalRecipeFetchResults];
    [favoritesArray sortUsingDescriptors:sortDescriptors];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self getRecipes];
    //[self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRecipes];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getRecipes];
    /*
    //Get the Managed Object Context
    GCAppDelegate *d = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = d.getContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        //handle the error
    }

    //Get the Favorites from the Managed Object Context
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //Sort the Favorites by title
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    //Fetch the PersonalRecipes
    NSFetchRequest *otherRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personalRecipe = [NSEntityDescription entityForName:@"PersonalRecipe" inManagedObjectContext:managedObjectContext];
    
    [otherRequest setEntity:personalRecipe];
    [otherRequest setSortDescriptors:sortDescriptors];
    
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    
    NSMutableArray *personalRecipeFetchResults = [[managedObjectContext executeFetchRequest:otherRequest error:&error] mutableCopy];
    if (personalRecipeFetchResults == nil) {
        // Handle the error.
    }
    
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    [allResults addObjectsFromArray:mutableFetchResults];
    [allResults addObjectsFromArray:personalRecipeFetchResults];
//    [self setFavoritesArray:mutableFetchResults];
    [self setFavoritesArray:allResults];
//    [favoritesArray addObjectsFromArray:mutableFetchResults];
//    [favoritesArray addObjectsFromArray:personalRecipeFetchResults];
    [favoritesArray sortUsingDescriptors:sortDescriptors];
     */
    
    [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Hoefler Text" size:21.0], UITextAttributeFont, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [favoritesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Favorite *favorite = (Favorite *)[favoritesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [favorite title];
    cell.detailTextLabel.text = [favorite ingredients];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    cell.textLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Delete";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // Delete the managed object at the given index path.
        NSManagedObject *favoriteToDelete = [favoritesArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:favoriteToDelete];
        
        // Update the array and table view.
        [favoritesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // Commit the change.
        NSError *error;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
            UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not save your recipes!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
            [v show];
        }
    }  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[[favoritesArray objectAtIndex:indexPath.row] typeOfRecipe] isEqualToString:@"Favorite"]) {
        
        selectedHtml = [[favoritesArray objectAtIndex:indexPath.row] html];
        selectedIngredients = [[favoritesArray objectAtIndex:indexPath.row] ingredients];

        [self performSegueWithIdentifier:@"ShowFavoriteDetailView" sender:self];

    }
    else if([[[favoritesArray objectAtIndex:indexPath.row] typeOfRecipe] isEqualToString:@"PersonalRecipe"]){
        
        selectedInstructions = [[favoritesArray objectAtIndex:indexPath.row] instructions];
//        NSLog(@"selected instructions is:  %@",selectedInstructions);
        selectedIngredients = [[favoritesArray objectAtIndex:indexPath.row] ingredients];
//        NSLog(@"selected ingredients is: %@",selectedIngredients);
        selectedTitle = [[favoritesArray objectAtIndex:indexPath.row] title];
//        NSLog(@"selected title is: %@",selectedTitle);
        
        [self performSegueWithIdentifier:@"ShowPersonalRecipeDetailView" sender:self];

    }
//    NSLog(@"the html you're trying to view now is: %@",[[favoritesArray objectAtIndex:indexPath.row] html]);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowFavoriteDetailView"]) {
        
        GCFavoriteDetailViewController *target = [segue destinationViewController];
        [target setUrl:selectedHtml andIngredients:selectedIngredients];
    }
    if([[segue identifier] isEqualToString:@"ShowPersonalRecipeDetailView"]){
        
        GCPersonalRecipeDetailViewController *otherTarget = [segue destinationViewController];
        [otherTarget setRecipeTitle:selectedTitle withIngredients:selectedIngredients withInstructions:selectedInstructions];
    }
}

@end
