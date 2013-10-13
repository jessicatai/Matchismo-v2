//
//  SetCard.h
//  Matchismo
//
//  Created by Jessica Tai on 10/11/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) int count;

+ (NSArray *)validShapes;
+ (NSArray *)validColor;
+ (NSArray *)validShading;
+ (NSArray *)validCounts;
+ (NSUInteger) maxCount;

@end
