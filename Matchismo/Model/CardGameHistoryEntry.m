//
//  CardGameHistoryEntry.m
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameHistoryEntry.h"
#import "Card.h"

@implementation CardGameHistoryEntry

- (instancetype)initWithCards:(NSMutableArray *)cards usingPoints:(int)points
{
    self = [super init];
    if (self) {
        for (Card *card in cards) {
            [self.cards addObject:card];
        }
        self.points = points;
    }
    return self;
}

@end
