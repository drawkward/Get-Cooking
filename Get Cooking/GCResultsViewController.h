//
//  GCResultsViewController.h
//  Get Cooking
//
//  Created by RYAN on 8/12/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCResultsViewController : UITableViewController

-(void)setSearchParametersAndFetchRecipes:(NSString *)keyword withIngredients:(NSString *)ingredients;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *favoritesArray;

@end
