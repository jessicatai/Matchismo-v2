//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Jessica Tai on 10/11/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck
- (instancetype) init
{
    self = [super init];
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            NSLog(@"Created set deck with cards w %@!", shape);
            for (NSString *color in [SetCard validColor]) {
                for (NSString *shading in [SetCard validShading]) {
                    for (NSUInteger count = 1; count <= [SetCard maxCount]; count++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.count = count;
                        card.shading = shading;
                        card.color = color;
                        card.shape = shape;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
