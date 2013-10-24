//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"


@interface CardGameViewController : UIViewController <UICollectionViewDataSource>
@property (strong, nonatomic) Deck *deck;   //abstract
@property (strong, nonatomic) CardMatchingGame *game; //abstract
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardsLabel;
@property (strong, nonatomic) IBOutlet UIButton *restartButton;
@property (nonatomic) NSUInteger difficulty;

@property (nonatomic) NSUInteger startingCardCount;

- (NSAttributedString *)titleForCard:(Card *) card; // abstract
- (UIImage *)backgroundImageForCard:(Card *)card; // abstract

@end
