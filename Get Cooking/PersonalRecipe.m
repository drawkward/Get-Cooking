//
//  PersonalRecipe.m
//  Get Cooking
//
//  Created by RYAN on 8/21/13.
//  Copyright (c) 2013 Ryan McNeely. All rights reserved.
//

#import "PersonalRecipe.h"


@implementation PersonalRecipe

@dynamic title;
@dynamic ingredients;
@dynamic instructions;

- (NSString *)typeOfRecipe{
    return @"PersonalRecipe";
}

@end
