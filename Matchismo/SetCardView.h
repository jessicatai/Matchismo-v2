//
//  SetCardView.h
//  Matchismo
//
//  Created by Jessica Tai on 10/21/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic) int count;
@property (nonatomic) int color;
@property (nonatomic) int shape;
@property (nonatomic) int shading;
@property (nonatomic,getter=isChosen) BOOL chosen;

@end
