//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Jessica Tai on 10/23/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
