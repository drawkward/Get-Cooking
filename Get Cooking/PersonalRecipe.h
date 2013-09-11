//
//  PersonalRecipe.h
//  Get Cooking
//
//  Created by RYAN on 8/21/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonalRecipe : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSString * instructions;

- (NSString *)typeOfRecipe;

@end
