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
- (void) viewDidLoad
{
    [super viewDidLoad];
    // initialize game without waiting for user input
    [self updateUI];
}

- (CardMatchingGame *)game
{
    return nil;
}

// abstract method
-(CardMatchingGame *) createGame
{
    return nil;
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
    self.game = nil;
    [self.game.chosenCards removeAllObjects];
    
    // reset the score label to 0
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    [self updateUI];
    
    // display the difficulty control
    self.difficultyControl.enabled = YES;
}



- (void)updateUI
{
    NSMutableAttributedString *cardsText = [[NSMutableAttributedString alloc] initWithString:@""];
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        // print out text for chosen cards with non-empty titles
        if ([self.game.chosenCards containsObject:card]) {
            [cardsText appendAttributedString: [self getTextForCard:card]];
            // space out card titles with tab
            [cardsText appendAttributedString:[[NSAttributedString  alloc] initWithString: @"\t"]];
        }
        
        
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
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

// abstract
- (NSAttributedString *)getTextForCard:(Card *) card
{
    return nil;
}

@end
