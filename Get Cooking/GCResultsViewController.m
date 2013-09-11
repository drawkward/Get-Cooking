//
//  GCResultsViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/12/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//
/*
 This view controller displays the results of the http request sent to
 the RecipePuppy API in a TableView.  The user can tap on a TableViewCell
 to view the recipe's corresponding web page. 
 */

#import "GCAppDelegate.h"
#import "GCResultsViewController.h"
#import "GCResultDetailViewController.h"
#import "Favorite.h"

@interface GCResultsViewController ()

@property (nonatomic, strong) NSMutableDictionary *jsonRecipeArray;
@property (nonatomic, strong) NSMutableData *recipeData;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSString *currentRecipeKeyword;

@property (strong, nonatomic) NSString *selectedRecipe;
@property (strong, nonatomic) NSString *selectedIngredients;

@property (strong, nonatomic) NSString *enteredKeyword;
@property (strong, nonatomic) NSString *enteredIngredients;

@property (strong, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation GCResultsViewController

@synthesize jsonRecipeArray;
@synthesize recipeData;
@synthesize navBar;
@synthesize currentRecipeKeyword;
@synthesize selectedRecipe;
@synthesize selectedIngredients;
@synthesize enteredIngredients;
@synthesize enteredKeyword;
@synthesize stepper;

@synthesize managedObjectContext;
@synthesize favoritesArray;

//Action sent when stepper buttons are pressed. Increments/decrements the "page" parameter sent to RecipePuppy API and
//sends a new request, updates table view data.
- (IBAction)stepperPressed:(UIStepper *)sender {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url;
    
    if (enteredIngredients) {
        url = [[[[[@"http://www.recipepuppy.com/api/?i="
                       stringByAppendingString:enteredIngredients]
                      stringByAppendingString:@"&q="]
                     stringByAppendingString:enteredKeyword]
                stringByAppendingString:@"&p="]
               stringByAppendingString:[NSString stringWithFormat:@"%f",[stepper value]]];
    }else
        {
        url = [[[@"http://www.recipepuppy.com/api/?q="
                           stringByAppendingString:enteredKeyword]
                          stringByAppendingString:@"&p="]
                         stringByAppendingString:[NSString stringWithFormat:@"%f",[stepper value]]];
        }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [connection start];
    
}

//Method called by GCViewController when sending user-input search parameters.
//This sets the value for the navBar title text, and formats the URL used in the
//HTTP request sent to the RecipePuppy API
-(void)setSearchParametersAndFetchRecipes:(NSString *)keyword withIngredients:(NSString *)ingredients{
    
    self.currentRecipeKeyword = keyword;
    
    self.enteredKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.enteredIngredients = ingredients;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = [[[@"http://www.recipepuppy.com/api/?i="
                      stringByAppendingString:ingredients]
                     stringByAppendingString:@"&q="]
                     stringByAppendingString:enteredKeyword];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [connection start];
}

// initialize recipeData if a response is received from the query
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    recipeData = [[NSMutableData alloc] init];
//    NSLog(@"received response");
}

//  pour the data stream into recipeData until it runs out
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
        [recipeData appendData:data];
//        NSLog(@"received data");
    
}

// hide the refresh control, reload the table view data, and initialize the jsonTwitterArray with the fetched data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
        jsonRecipeArray = [NSJSONSerialization JSONObjectWithData:recipeData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"json recipe array results count equals %d", [[jsonRecipeArray objectForKey:@"results"] count]);
    if ([[jsonRecipeArray objectForKey:@"results"] count] == 0) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"End of the line!" message:@"You've seen all there is to see!  There are no remaining search results.  Maybe you should try to refine your search results by adding ingredients, or just quit being so dang indecisive!" delegate:self cancelButtonTitle:@"wtvr..." otherButtonTitles:nil];
        [a show];
    }
        [self.tableView reloadData];
}

// if there's no internet connection, show an alert view
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"AWWW DANG!" message:@"FAIL!  Make sure you have an internet connection and try again." delegate:nil cancelButtonTitle:@"Okay..." otherButtonTitles:nil];
        [errorView show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//This wasn't modified
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Set font for navBar text, and set navBar title to "!?" if no search parameter was given
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GCAppDelegate *d = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = d.getContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // do something if context is null
    }
    /*
    // Get the existing events array from the managedObjectContext
    // then sorth them, so we can then add a new one when the timer is
    // stopped and the save button is pressed.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    
    [self setFavoritesArray:mutableFetchResults];
    */
    [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Hoefler Text" size:21.0], UITextAttributeFont, nil]];
    
    if ([currentRecipeKeyword isEqualToString:@""]){
        [self.navBar topItem].title = @"!?";
    }
    else{
//    [self.navBar topItem].title = currentRecipeKeyword;
    }
}

//Dismiss the view controller when the "X" button is pressed
- (IBAction)xPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//This was not modified
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return [[jsonRecipeArray objectForKey:@"results"] count];
}

//Populate the tableView with cells containing recipe titles and ingredient lists
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    // May want to use this method to clean up any percent-decoding issues when pulling titles in search results
    // - (NSString *)stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding
    // want to tack this method onto the end of the declaration of *recipeTitle
    
    NSString *recipeTitle = [[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = recipeTitle;
    NSString *recipeIngredients = [[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"ingredients"];
    cell.detailTextLabel.text = recipeIngredients;
    return cell;
}

// this method is used to format cell text attributes
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    cell.textLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

//Using "swipe-to-delete", the user can add recipes to "Favorites"
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Here, we'll add the selected recipe to Favorites, rather than deleting it.
        Favorite *favorite = (Favorite *)[NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:managedObjectContext];
        [favorite setHtml:[[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"href"]];
        [favorite setTitle:[[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [favorite setIngredients:[[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"ingredients"]];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
            UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"This shouldn't have happend, but it seems as though your recipe was not successfully saved to your Favorites." delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
            [v show];
        }
        
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"oOoOo!" message:[NSString stringWithFormat:@"%@ was successfully added to your Favorites.", [[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"title"]] delegate:self cancelButtonTitle:@"COOL!" otherButtonTitles:nil];
        [a show];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//Add a bit of personality
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"ME GUSTA!";
}


#pragma mark - Table view delegate

//Send the selected recipe's URL to the GCResultDetailViewController for presentation in it's webView
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowResultDetailView"]){
        GCResultDetailViewController *target = [segue destinationViewController];
        [target setUrl:selectedRecipe andIngredients:selectedIngredients];
    }
}

//Segue to GCResultDetailViewController when a row is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRecipe = [[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"href"];
    self.selectedIngredients = [[[jsonRecipeArray objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"ingredients"];
//    NSLog(@"selected recipe is = %@",selectedRecipe);
    
    [self performSegueWithIdentifier:@"ShowResultDetailView" sender:self];
}

@end
