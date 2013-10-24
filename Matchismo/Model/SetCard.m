//
//  SetCard.m
//  Matchismo
//
//  Created by Jessica Tai on 10/11/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    NSMutableSet *shapeSet =[[NSMutableSet alloc] init];
    NSMutableSet *colorSet =[[NSMutableSet alloc] init];
    NSMutableSet *shadingSet =[[NSMutableSet alloc] init];
    NSMutableSet *countSet =[[NSMutableSet alloc] init];
    
    // add current card's attributes to respective sets
    [self addCardAttributesToSet:self withShapeSet:shapeSet withColorSet:colorSet withShadingSet:shadingSet withCountSet:countSet];
    
    if ([otherCards count] > 0) {
        // add other card's attributes to respective sets
        for (SetCard *otherCard in otherCards) {
            [self addCardAttributesToSet:otherCard withShapeSet:shapeSet withColorSet:colorSet withShadingSet:shadingSet withCountSet:countSet];
        }
        // all the same attribute values = set size is 1
        // all different attribute values = set size is N, where N = # of cards in set
        bool isSet = NO;
        int N = [otherCards count] + 1;
        if ([self isSetMatch:shapeSet withNCards:N] && [self isSetMatch:colorSet withNCards:N] && [self isSetMatch:shadingSet withNCards:N] && [self isSetMatch:countSet withNCards:N]) {
            isSet = YES;
        }
        score = isSet ? 1 : 0;
    }
    
    return score;
}

- (NSString *) contents
{
    return nil;
}
            
- (bool) isSetMatch:(NSMutableSet *)attributeSet
          withNCards:(int) N
{
    int setSize = [attributeSet count];
    return (setSize == 1 || setSize == N) ? YES : NO;
}

- (void) addCardAttributesToSet:(SetCard *)card
                   withShapeSet:(NSMutableSet *) shapeSet
                   withColorSet:(NSMutableSet *) colorSet
                 withShadingSet:(NSMutableSet *) shadingSet
                   withCountSet:(NSMutableSet *) countSet
{
    [shapeSet addObject:[NSNumber numberWithInt:card.shape]];
    [colorSet addObject:[NSNumber numberWithInt:card.color]];
    [shadingSet addObject:[NSNumber numberWithInt:card.shading]];
    [countSet addObject:[NSNumber numberWithInt:card.count]];
}

+ (NSArray *)validShapes
{
    return @[@1,@2,@3];
}

+ (NSArray *)validColor
{
    return @[@1,@2,@3];
}

+ (NSArray *)validShading
{
    return @[@1,@2,@3];
}

+ (NSArray *)validCounts
{
    return @[@1,@2,@3];
}

+ (NSUInteger)maxCount
{
    return 3;
}

@end
