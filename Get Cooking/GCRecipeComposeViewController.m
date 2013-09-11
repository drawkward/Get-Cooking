//
//  GCRecipeComposeViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/21/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCRecipeComposeViewController.h"
#import "GCAppDelegate.h"
#import "PersonalRecipe.h"

@interface GCRecipeComposeViewController () <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleField;

@property (strong, nonatomic) IBOutlet UITextField *ingredientField;

@property (strong, nonatomic) IBOutlet UITextView *recipeTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation GCRecipeComposeViewController

@synthesize titleField;
@synthesize ingredientField;
@synthesize recipeTextView;
@synthesize scrollView;
@synthesize navBar;
@synthesize recipesArray;
@synthesize managedObjectContext;

//determine screen size of device and show/hide the appropriate info button
-(void)determineScreenSizeAndDisplayAppropriateButtons{
    if ([UIScreen mainScreen].bounds.size.height < 568){
        [recipeTextView setFrame:CGRectMake(20.0, 223.0, 280.0, 173.0)];
    }
    else{
        [recipeTextView setFrame:CGRectMake(20.0, 223.0, 280.0, 261.0)];
    }
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    //Here, we'll add the selected recipe to Favorites, rather than deleting it.
    PersonalRecipe *recipe = (PersonalRecipe *)[NSEntityDescription insertNewObjectForEntityForName:@"PersonalRecipe" inManagedObjectContext:managedObjectContext];
    
    [recipe setTitle:[titleField text]];
    [recipe setIngredients:[ingredientField text]];
    [recipe setInstructions:[recipeTextView text]];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Handle the error.
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not save your new recipe!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }

    UIAlertView *b = [[UIAlertView alloc] initWithTitle:@"Well done!" message:@"Your recipe was saved successfully!" delegate:self cancelButtonTitle:@"WOOO!" otherButtonTitles:nil];
    [b show];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)xPressed:(UIBarButtonItem *)sender {
    
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"WAIT!" message:@"Are you sure you want to cancel without saving?" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:@"NO!",nil];
    [a show];
}

- (IBAction)scrollViewTapped:(UITapGestureRecognizer *)sender {
    [ingredientField resignFirstResponder];
    [recipeTextView resignFirstResponder];
    [titleField resignFirstResponder];
    [self setEditing:NO];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [recipeTextView setText:@""];
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
    
    //Get the Managed Object Context
    GCAppDelegate *d = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = d.getContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        //handle the error
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not find managed object context!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }
    
    //Get the Favorites from the Managed Object Context
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonalRecipe" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //Sort the Favorites by title
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Save Error!" message:@"Could not fetch your recipes!" delegate:self cancelButtonTitle:@"Oh DANG!" otherButtonTitles:nil];
        [v show];
    }
    
    [self setRecipesArray:mutableFetchResults];
    
    
	// Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    [titleField setDelegate:self];
    [ingredientField setDelegate:self];
    [recipeTextView setDelegate:self];
    [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Hoefler Text" size:21.0], UITextAttributeFont, nil]];

}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //    editingNotes = true;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, ingredientField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, ingredientField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    if (!CGRectContainsPoint(aRect, titleField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, titleField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    if (!CGRectContainsPoint(aRect, recipeTextView.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, recipeTextView.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
