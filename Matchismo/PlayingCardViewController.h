//
//  PlayingCardViewController.h
//  Matchismo
//
//  Created by Jessica Tai on 10/19/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"

@interface PlayingCardViewController : CardGameViewController
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *flipCardGesture;

@end
