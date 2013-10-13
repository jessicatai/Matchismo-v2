//
//  CardGameViewController.m
//  Matchismo
//  abstract class
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (nonatomic, strong) NSMutableAttributedString *attributedDescription;
@end

@implementation CardGameViewController
- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}

// abstract method
- (Deck *)createDeck
{
    return nil;
}

- (NSMutableAttributedString *) attributedDescription
{
    if (!_attributedDescription) _attributedDescription = [[NSMutableAttributedString alloc] init];
    return _attributedDescription;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    //NSLog(@"in abstract touch card button");
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    //NSLog(@"chosen button index: %d", chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    self.difficultyControl.enabled = NO;
}

- (IBAction)touchRestartButton:(UIButton *)sender
{
    // reset game deck
    _game = nil;
    
    // reset the score label to 0
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    [self updateUI];
    
    // display the difficulty control
    self.difficultyControl.enabled = YES;
}



- (void)updateUI
{
    NSLog(@"set - updating ui");
    
    NSMutableAttributedString *cardsText = [[NSMutableAttributedString alloc] initWithString:@""];
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        if ([self.game.chosenCards containsObject:card]) {
            [cardsText appendAttributedString: cardButton.titleLabel.attributedText];
            // space out card titles with tab
            [cardsText appendAttributedString:[[NSAttributedString  alloc] initWithString: @"\t"]];
        }
    }
    self.cardsLabel.attributedText = cardsText;
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString: self.game.description ? self.game.description: @""];
}

// abstract
- (NSAttributedString *)titleForCard:(Card *) card
{
    return nil;
}

// abstract
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}

- (void) constructDescription:(int) points
                  withCurrentCard: (Card *)card
{
    // clear the current description
    self.attributedDescription = [[NSMutableAttributedString alloc] init];
    
    // find other chosen cards
    NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
    
    
    // matches have positive points, mismatches have negative points
//    if (points > 0) {
//        [_attributedDescription appendAttributedString:[[NSAttributedString  alloc] initWithString: @"Matched "]];
//    } else {
//        [_attributedDescription appendAttributedString:[[NSAttributedString  alloc] initWithString:@"Penalty! Mismatched "]];
//    }
//    
    // list the cards involved in this (mis)match
    for (Card *otherCard in matchedCards) {
        [self.attributedDescription appendAttributedString: [self titleForCard:otherCard]];
    }
    
    [self.attributedDescription appendAttributedString: [self titleForCard:card]];
    [self.attributedDescription appendAttributedString:[[NSAttributedString  alloc] initWithString: self.game.description]];
//    [_attributedDescription appendAttributedString: [[NSAttributedString  alloc] initWithString: [NSString stringWithFormat:@" for %d points.", points]]];
}

- (void) printChosenCards: (NSUInteger) index
{
    _attributedDescription = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.game.chosenCards) {
        [_attributedDescription appendAttributedString: [self titleForCard:card]];
    }
}



@end
