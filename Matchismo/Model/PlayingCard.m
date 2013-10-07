//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


-(int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] > 0) {
        for (PlayingCard *otherCard in otherCards){
            if (otherCard.rank == self.rank) {
                score += 4;
            }
            else if ([otherCard.suit isEqualToString:self.suit]) {
                score += 1;
            }
        }
        NSRange theRange;
        theRange.length = [otherCards count] - 1;
        theRange.location = 1;
        // recursively search for other pair-wise matches
        score += [[otherCards firstObject] match: [otherCards subarrayWithRange:theRange]];
    }
    return score;
}

- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}
@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♣",@"♦",@"♥",@"♠"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count] - 1;
}

@end
