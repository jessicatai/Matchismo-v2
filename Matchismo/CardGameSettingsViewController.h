//
//  CardGameSettingsViewController.h
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchismoDifficultyControl;
@property (weak, nonatomic) IBOutlet UITextField *matchBonusTextField;
@property (weak, nonatomic) IBOutlet UIStepper *matchBonusStepper;
@property (weak, nonatomic) IBOutlet UITextField *mismatchPenaltyTextField;
@property (weak, nonatomic) IBOutlet UIStepper *mismatchPenaltyStepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *costToChooseControl;


@end
