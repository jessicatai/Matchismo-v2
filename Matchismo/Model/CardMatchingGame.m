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

- (void) constructDescription:(int) points usingCards: (NSMutableArray *)matchedCards currentCard: (Card *)card
{
    // clear the current description
    _description = [NSMutableString string];

    // matches have positive points, mismatches have negative points
    if (points > 0) {
        [_description appendString: @"Matched "];
    } else {
        [_description appendString:@"Penalty! Mismatched "];
    }
    
    // list the cards involved in this (mis)match
    for (Card *otherCard in matchedCards) {
        [_description appendString:otherCard.contents];
    }
    
    [_description appendString: card.contents];
    [_description appendString: [NSString stringWithFormat:@" for %d points.", points]];
}

static const int MISMATCH_PENALTY = -2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = -1;

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    _description = [NSMutableString string];
    if (!card.isMatched) {
        // toggle a currently chosen card to not chosen
        if (card.isChosen) {
            card.chosen = NO;
            // describe all chosen cards
            [self printChosenCards:index];
            
        } else {
            // segment control index 0 = match 1 other card, index 1 = match 2 other cards
            int numCardsToMatch = self.numMatchedCards + 1;
            
            // find other chosen cards
            NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [matchedCards addObject:otherCard];
                }
            }
            
            // when the correct number of cards to check have been selected, perform the matching
            if ([matchedCards count] == numCardsToMatch) {
                int matchScore = [card match:matchedCards];
                // for any matched 2, take all 3 cards out of the game
                int points;
                if (matchScore) {
                    // Note: this scoring works specifically for 1 and 2 cards to match (2,3-match variant games)
                    points = matchScore * MATCH_BONUS / numCardsToMatch;
                    
                } else {
                    points = MISMATCH_PENALTY;
                }
                
                // set card status and message for each matched card
                for (Card *otherCard in matchedCards) {
                    otherCard.matched = matchScore ? YES : NO;
                    otherCard.chosen = matchScore ? YES : NO;
                }
                // set description based on scenario
                [self constructDescription:points usingCards:matchedCards currentCard:card];
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