//
//  GCResultDetailViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/12/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCResultDetailViewController.h"
#import "GCIngredientsViewController.h"

@interface GCResultDetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *ingredients;


@end

@implementation GCResultDetailViewController

@synthesize webView;
@synthesize url;
@synthesize ingredients;

- (IBAction)xPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUrl:(NSString *)u andIngredients:(NSString *)i{
    url = u;
    ingredients = i;
}
- (IBAction)ingredientsPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ShowIngredientsView" sender:self];
}


- (NSArray *)parseIngredients:(NSString *)i{
    NSArray *ingredientsList = [i componentsSeparatedByString:@","];
    return ingredientsList;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowIngredientsView"]){
        GCIngredientsViewController *target = [segue destinationViewController];
        [target setIngredients:[self parseIngredients:ingredients]];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
