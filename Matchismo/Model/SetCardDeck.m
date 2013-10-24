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
        for (NSNumber* shape in [SetCard validShapes]) {
            for (NSNumber* color in [SetCard validColor]) {
                for (NSNumber* shading in [SetCard validShading]) {
                    for (int count = 1; count <= [SetCard maxCount]; count++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.count = count;
                        card.shading = [shading intValue];
                        card.color = [color intValue];
                        card.shape = [shape intValue];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
