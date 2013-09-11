//
//  GCViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/12/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCViewController.h"
#import "GCResultsViewController.h"


@interface GCViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *keywordField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;

@end

@implementation GCViewController

@synthesize keywordField;
@synthesize ingredientField;
@synthesize scrollView;

@synthesize infoLabel;
@synthesize infoView;
@synthesize doneButton;
@synthesize creditLabel;

- (IBAction)donePressed:(UIButton *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [infoLabel setAlpha:0.0];
    [doneButton setAlpha:0.0];
    [infoView setAlpha:0.0];
    [creditLabel setAlpha:0.0];
    [UIView commitAnimations];
}

- (IBAction)favoritesPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ShowFavoritesView" sender:self];
}

- (IBAction)infoPressed:(UIButton *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [infoLabel setAlpha:1.0];
    [creditLabel setAlpha:1.0];
    [doneButton setAlpha:0.6];
    [infoView setAlpha:0.7];
    [UIView commitAnimations];
}

- (IBAction)imageViewTapped:(UITapGestureRecognizer *)sender {
    [keywordField resignFirstResponder];
    [ingredientField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange spaceRange = [string rangeOfString:@" "];
    if (spaceRange.location != NSNotFound)
    {
        if (textField == ingredientField){
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"ShowResultsView" sender:self];
    return NO;
}

/*
 This has been left out, due to the fact that I find it to be redundant.
 It was initially included for testing purposes only.
 
- (IBAction)searchPressed:(UIButton *)sender {
    [keywordField endEditing:YES];
    [ingredientField endEditing:YES];
    [self performSegueWithIdentifier:@"ShowResultsView" sender:self];
}
*/


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"ShowResultsView"]){
        
        GCResultsViewController *target = [segue destinationViewController];
        
//        NSString *encodedKeyword = [[keywordField text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [target setSearchParametersAndFetchRecipes:[keywordField text] withIngredients:[ingredientField text]];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [keywordField setDelegate:self];
    [ingredientField setDelegate:self];

    [keywordField setReturnKeyType:UIReturnKeySearch];
    [ingredientField setReturnKeyType:UIReturnKeySearch];
    [self registerForKeyboardNotifications];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [keywordField setClearsOnBeginEditing:YES];
    [ingredientField setClearsOnBeginEditing:YES];
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
    if (!CGRectContainsPoint(aRect, keywordField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, keywordField.frame.origin.y-kbSize.height);
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
