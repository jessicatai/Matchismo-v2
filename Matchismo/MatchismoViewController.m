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
    _game.numCardsInMatch = self.difficultyControl.selectedSegmentIndex + 2;
    return _game;
}


- (Deck *)createDeck
{
    NSLog(@"matchismo create deck");
    return [[PlayingCardDeck alloc] init];
}

//- (IBAction)touchRestartButton:(UIButton *)sender
//{
//    [self.game setNumMatchedCards:self.difficultyControl.selectedSegmentIndex];
//}


- (IBAction)touchDifficultyControl:(UISegmentedControl *)sender {
    [self.game setNumCardsInMatch:self.difficultyControl.selectedSegmentIndex];
}

- (NSAttributedString *)titleForCard:(Card *) card
{
    return [[NSAttributedString alloc] initWithString:(card.isChosen ? card.contents : @"") attributes:@{}];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
