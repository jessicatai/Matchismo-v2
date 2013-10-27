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
@property (nonatomic, strong) NSMutableArray *cards; // of Card

@end

@implementation CardMatchingGame
- (NSUInteger) currentCardCount
{
    return [self.cards count];
}

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

- (NSMutableArray *) historyEntries {
    if (!_historyEntries) _historyEntries = [[NSMutableArray alloc] init];
    return _historyEntries;
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
        _deck = deck;
    }
    return self;
}


- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void) removeCardAtIndex:(NSUInteger) index {
    [self.cards removeObjectAtIndex:index];
}

- (NSUInteger) addCards:(NSUInteger) numCardsToAdd {
    NSUInteger cardsAdded = 0;
    for (int i = 0; i < numCardsToAdd; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
            cardsAdded++;
        } else {
            break;
        }
    }
    return cardsAdded;
}

- (Card *) addCard {
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.cards addObject:card];
    }
    return card;
}

-(void) addEntryWithCard:(NSMutableArray *) cards withPoints:(int) points
{
    CardGameHistoryEntry *entry = [[CardGameHistoryEntry alloc] initWithCards:cards usingPoints:points];
    [self.historyEntries addObject:entry];
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
            self.points = NSNotFound;
            
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
                    points = matchScore * [self getPointsForKey:@"matchBonus" withDefaultValue:MATCH_BONUS] + (self.numCardsInMatch * -1 * [self getPointsForKey:@"costToChoose" withDefaultValue:COST_TO_CHOOSE]);
                    NSLog(@"match");

                } else {
                    points = [self getPointsForKey:@"mismatchPenalty" withDefaultValue:MISMATCH_PENALTY];
                }
                self.score += points;
                
                // set card status and message for each matched card
                for (Card *otherCard in self.chosenCards) {
                    otherCard.matched = matchScore ? YES : NO;
                    otherCard.chosen = matchScore ? YES : NO;
                }
                card.matched = matchScore ? YES : NO;
                
                // update to reflext the most recently awarded/decremented points
                self.points = points;
                
                
            } else {
                self.points = NSNotFound;
            }
            // for each card button touched, there is a cost (can be overridden in settings)
            self.score += [self getPointsForKey:@"costToChoose" withDefaultValue:COST_TO_CHOOSE];
                 
            [self.chosenCards addObject:card];
            card.chosen = YES;
            
        }
    }
}


// retrieve NSUserDefaults potentially changed in the settings
- (int) getPointsForKey:(NSString *)key withDefaultValue:(int) val {
    NSString *str =[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return str ? [str intValue] : val;
}


- (void) updateChosenCards {
    [self.chosenCards removeAllObjects];
    for (Card * card in self.cards){
        if (card.isChosen && !card.isMatched)
            [self.chosenCards addObject:card];
    }
}

@end