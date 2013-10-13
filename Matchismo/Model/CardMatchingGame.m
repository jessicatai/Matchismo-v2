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
    NSLog(@"init with card count %d card matching game", count);
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
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = -1;

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSLog(@"size of chosen cards: %d", [self.chosenCards count]);
    if (!card.isMatched) {
        // toggle a currently chosen card to not chosen
        if (card.isChosen) {
            card.chosen = NO;
            [self updateChosenCards];
            self.description = @"";
            
        } else {
            // segment control index 0 = match 1 other card, index 1 = match 2 other cards
            int numCardsToMatch = 2;//self.numMatchedCards + 1;
            
            
            [self updateChosenCards];

            // when the correct number of cards to check have been selected, perform the matching
            if ([self.chosenCards count] == numCardsToMatch) {
                int matchScore = [card match:self.chosenCards];
                // for any matched 2, take all 3 cards out of the game
                int points;
                if (matchScore) {
                    points = matchScore * MATCH_BONUS;
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
            
            NSLog(@"updated size of chosen cards: %d", [self.chosenCards count]);
        }
    }
}

- (NSString *) setDescriptionTextForPoints:(int) points{
    return[NSString stringWithFormat:@"%1$@ for %2$d points.", points > 0 ? @"Match" : @"Penalty, mismatched",points];
}

- (void) updateChosenCards {
    [self.chosenCards removeAllObjects];
    NSLog(@"empty size chosen cards: %d", [self.chosenCards count]);
    for (Card * card in self.cards){
        if (card.isChosen && !card.isMatched)
            [self.chosenCards addObject:card];
    }
}

@end