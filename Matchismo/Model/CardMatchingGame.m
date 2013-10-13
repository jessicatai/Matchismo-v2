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
@property (nonatomic, readwrite) NSString *description;
@property (nonatomic, strong) NSMutableArray *cards; // of Card

@end

@implementation CardMatchingGame
- (NSMutableArray *) chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}


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

static const int MISMATCH_PENALTY = -2;
static const int COST_TO_CHOOSE = -1;
static const int MATCH_BONUS = 4;
- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        // toggle a currently chosen card to not chosen
        if (card.isChosen) {
            card.chosen = NO;
            [self updateChosenCards];
            self.description = @"";
            
        } else {
            // get chosen cards (excluding current card)
            [self updateChosenCards];

            // when the correct number of other cards to check have been chosen, perform the matching
            if ([self.chosenCards count] == self.numCardsInMatch - 1) {
                int matchScore = [card match:self.chosenCards];
                // for any matched 2, take all 3 cards out of the game
                int points;
                if (matchScore) {
                    // will give user a net gain of 4 points to find the match
                    points = matchScore * MATCH_BONUS + (self.numCardsInMatch * -1 * COST_TO_CHOOSE);
;
                } else {
                    points = MISMATCH_PENALTY;
                }
                self.score += points;
                
                // set card status and message for each matched card
                for (Card *otherCard in self.chosenCards) {
                    otherCard.matched = matchScore ? YES : NO;
                    otherCard.chosen = matchScore ? YES : NO;
                }
                card.matched = matchScore ? YES : NO;
                
                // update the description to reflect the result choosing the card
                self.description = [self setDescriptionTextForPoints:points];
                
            } else {
                self.description = @"";
            }
            // for each card button touched, there is a cost
            self.score += COST_TO_CHOOSE;
            
            card.chosen = YES;
            [self.chosenCards addObject:card];
        }
    }
}

- (NSString *) setDescriptionTextForPoints:(int) points{
    return[NSString stringWithFormat:@"%1$@ for %2$d points.", points > 0 ? @"Match" : @"Penalty, mismatched",points];
}

- (void) updateChosenCards {
    [self.chosenCards removeAllObjects];
    for (Card * card in self.cards){
        if (card.isChosen && !card.isMatched)
            [self.chosenCards addObject:card];
    }
}

@end