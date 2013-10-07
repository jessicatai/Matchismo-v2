//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jessica Tai on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSMutableString *description;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void) printChosenCards: (NSUInteger) index
{
    _description = [NSMutableString string];
    for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
            [_description appendString: otherCard.contents];
        }
    }
}

static const int MISMATCH_PENALTY = -2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = -1;

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    _description = [NSMutableString string];
    if (!card.isMatched) {
        if (card.isChosen) {
            // toggle currently chosen card to not chosen
            card.chosen = NO;
            // describe all chosen cards
            [self printChosenCards:index];
            
        } else {
            // find other chosen cards
            NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [matchedCards addObject:otherCard];
                }
            }
            // when the correct number of cards to check have been selected, perform the matching
            // segment control index 0 = match 1 other card, index 1 = match 2 other cards
            if ([matchedCards count] == self.numMatchedCards + 1) {
                int matchScore = [card match:matchedCards];
                // for any matched 2, take all 3 cards out of the game
                int points;
                if (matchScore) {
                    [_description appendString: @"Matched "];
                    points = matchScore * MATCH_BONUS;
                    
                } else {
                    [_description appendString:@"Penalty! Mismatched "];
                    points = MISMATCH_PENALTY;
                }
                
                [_description appendString: card.contents];
                
                // set card status and message for each matched card
                for (Card *otherCard in matchedCards) {
                    otherCard.matched = matchScore ? YES : NO;
                    otherCard.chosen = matchScore ? YES : NO;
                    [_description appendString:otherCard.contents];
                }
                [_description appendString: [NSString stringWithFormat:@" for %d points.", points]];
                
                self.score += points;
                card.matched = matchScore ? YES : NO;

            } else {
                [self printChosenCards:index];
                Card *card = [self cardAtIndex:index];
                [_description appendString:card.contents];
            }
            
            card.chosen = YES;
            self.score += COST_TO_CHOOSE;
        }
    }
}

@end