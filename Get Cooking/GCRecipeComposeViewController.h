//
//  GCRecipeComposeViewController.h
//  Get Cooking
//
//  Created by RYAN on 8/21/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCRecipeComposeViewController : UIViewController{
    NSMutableArray *recipesArray;
    NSManagedObjectContext *managedObjectContext;
}

//- (void)addFavorite;
@property (nonatomic, retain) NSMutableArray *recipesArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
