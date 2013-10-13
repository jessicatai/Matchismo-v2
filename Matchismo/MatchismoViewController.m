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

- (Deck *)createDeck
{
    NSLog(@"matchismo create deck");
    return [[PlayingCardDeck alloc] init];
}

//- (void)updateUI
//{
//    NSLog(@"matchismo update UI");
//    for (UIButton *cardButton in self.cardButtons) {
//        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//        Card *card = [self.game cardAtIndex:cardButtonIndex];
//        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
//        cardButton.enabled = !card.isMatched;
//        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
//
//        self.descriptionLabel.attributedText = cardButton.titleLabel.attributedText;
//    }
//
//}
- (IBAction)touchRestartButton:(UIButton *)sender
{

    [self.game setNumMatchedCards:self.difficultyControl.selectedSegmentIndex];
}


- (IBAction)touchDifficultyControl:(UISegmentedControl *)sender {
    [self.game setNumMatchedCards:self.difficultyControl.selectedSegmentIndex];
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
