//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/11/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"


@interface MatchismoViewController ()

@end

@implementation MatchismoViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    // index 0 = match 2 cards, index 1 = match 3 cards
    _game.numCardsInMatch = [_game getPointsForKey:@"difficulty" withDefaultValue:0] + 2;
    return _game;
}


- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *) card
{
    return [[NSAttributedString alloc] initWithString:(card.isChosen ? card.contents : @"") attributes:@{}];
}

- (NSAttributedString *)getTextForCard:(Card *) card
{
    return [[NSAttributedString alloc] initWithString:(card.contents) attributes:@{}];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
