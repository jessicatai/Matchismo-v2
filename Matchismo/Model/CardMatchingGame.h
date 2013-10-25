//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Jessica Tai on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
#import "CardGameHistoryEntry.h"

@interface CardMatchingGame : NSObject

// designated initializer
-(instancetype) initWithCardCount:(NSUInteger)count usingDeck: (Deck *) deck;
- (void) chooseCardAtIndex:(NSUInteger)index;
- (void) removeCardAtIndex:(NSUInteger) index;
- (bool) addCards:(NSUInteger) numCardsToAdd;
- (Card *) cardAtIndex:(NSUInteger)index;
- (int) getPointsForKey:(NSString *)key withDefaultValue:(int) val;

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, strong) NSMutableArray *chosenCards;
@property (nonatomic, strong) NSMutableArray *historyEntries; // of CardGameHistoryEntry
@property (nonatomic, readwrite) NSInteger points;

// value indicates how many cards to match
@property (nonatomic) NSUInteger numCardsInMatch;

@property (nonatomic) NSUInteger currentCardCount;

@end