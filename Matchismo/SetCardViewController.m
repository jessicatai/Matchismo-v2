//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/22/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation SetCardViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        _game.points = NSNotFound;
        // set is always played with 3 cards
        _game.numCardsInMatch = 3;
    }
    return _game;
}

- (NSUInteger) startingCardCount
{
    return 12;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)drawRandomSetCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
         SetCard *setCard = (SetCard *)card;
        self.setCardView.color = setCard.color;
        self.setCardView.shape = setCard.shape;
        self.setCardView.shading = setCard.shading;
        self.setCardView.count = setCard.count;
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    NSLog(@"set swipe gestured recognized");
    [self drawRandomSetCard];
}

// TODO: after deck is exhausted, click re-deal then both de-deal and +3 card buttons are disabled
- (IBAction)touchAddCardsButton:(UIButton *)sender {
    NSUInteger cardsAdded = [self.game addCards:self.game.numCardsInMatch];
    // disable the button when there aren't enough cards left
    if (cardsAdded < self.game.numCardsInMatch) {
        sender.enabled = NO;
        sender.alpha = 0.3;
    }
    self.currentCardCount = [[self.gameView subviews] count] + cardsAdded;
    
    [UIView transitionWithView:self.view.superview
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self updateGridWithAnimation:NO];
                        [self updateUI];
                    }completion: NULL];
}

- (void) resetUIElements {
    // re-enable all the buttons
    [self.restartButton setEnabled:YES];
    [self.addCardsButton setEnabled:YES];
    self.addCardsButton.alpha = 1.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (UIView *)createCardViewWithFrame:(CGRect)frame usingCard:(Card*) card{
    return [[SetCardView alloc] initWithFrame:frame];
}

- (void) updateCardWithView:(UIView *)view usingCard:(Card*)card {
    if ([view isKindOfClass:[SetCardView class]] && [card isKindOfClass:[SetCard class]]) {
        SetCardView *setCardView = (SetCardView *)view;
        SetCard *setCard = (SetCard *)card;
        setCardView.color = setCard.color;
        setCardView.shape = setCard.shape;
        setCardView.shading = setCard.shading;
        setCardView.count = setCard.count;
        setCardView.chosen = setCard.chosen;
        if (setCard.isMatched) {
            NSLog(@"is matched");
            [UIView transitionWithView:setCardView.superview
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                NSUInteger index = [[self.gameView subviews] indexOfObject:setCardView];
                                [setCardView removeFromSuperview];
                                [self.game removeCardAtIndex:index];
                            }completion:^(BOOL finished) {
                                if (finished) {
                                    [self updateGridWithAnimation:NO];
                                    [self updateUI];
                                }
                            }];
            self.currentCardCount = [[self.gameView subviews] count];
        }
    }
}

@end
