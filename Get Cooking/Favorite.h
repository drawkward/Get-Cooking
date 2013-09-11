//
//  Favorite.h
//  Get Cooking
//
//  Created by RYAN on 8/15/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) NSString * ingredients;

- (NSString *)typeOfRecipe;

@end
