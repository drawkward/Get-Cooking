//
//  GCFavoriteDetailViewController.m
//  Get Cooking
//
//  Created by RYAN on 8/13/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "GCFavoriteDetailViewController.h"
#import "GCIngredientsViewController.h"

@interface GCFavoriteDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *ingredients;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GCFavoriteDetailViewController

@synthesize url;
@synthesize webView;
@synthesize ingredients;

- (void)setUrl:(NSString *)u andIngredients:(NSString *)i{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
