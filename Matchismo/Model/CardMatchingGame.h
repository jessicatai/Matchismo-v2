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

@interface CardMatchingGame : NSObject

// designated initializer
-(instancetype) initWithCardCount:(NSUInteger)count usingDeck: (Deck *) deck;
- (void) chooseCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, strong) NSMutableArray *chosenCards;

// value indicates how many cards to match
@property (nonatomic) NSUInteger numCardsInMatch;

@end