//
//  GCFavoritesViewController.h
//  Get Cooking
//
//  Created by RYAN on 8/13/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCFavoritesViewController : UITableViewController{
    NSMutableArray *favoritesArray;
    NSManagedObjectContext *managedObjectContext;
}

//- (void)addFavorite;
@property (nonatomic, retain) NSMutableArray *favoritesArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
