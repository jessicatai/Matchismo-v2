//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"


@interface CardGameViewController : UIViewController

// UI elements with polymorphic behavior
@property (strong, nonatomic) IBOutlet UIButton *restartButton;
@property (strong, nonatomic) IBOutlet UIView *gameView;

@property (strong, nonatomic) Deck *deck;   //abstract
@property (strong, nonatomic) CardMatchingGame *game; //abstract
@property (nonatomic) NSUInteger currentCardCount;

- (UIImage *)backgroundImageForCard:(Card *)card; // abstract

- (void)updateUI;
- (void)updateGridWithAnimation:(bool)isAnimated;
- (void) resetUIElements; // specific to each inherited subclass view

- (UIView *)createCardViewWithFrame:(CGRect)frame usingCard:(Card*) card; //abstract

- (void) updateCardWithView:(UIView *)view usingCard:(Card*)card; //abstract

- (void) animateTouchCardAction:(UIView *)view; // abstract

// animation
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicBehavior *behavior;

@end
