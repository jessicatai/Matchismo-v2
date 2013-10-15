//
//  CardGameSettingsViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameSettingsViewController.h"

@interface CardGameSettingsViewController ()

@end

@implementation
CardGameSettingsViewController

// load any previous settings
- (void) viewDidLoad {
    [self.matchismoDifficultyControl setSelectedSegmentIndex: [self loadPreviousSettingsWithKey:@"difficulty" usingDefaultValue:0]];
    
    // default index 0 = yes cost to choose value as -1 point
    // index 1 = no cost value as 0 point
    [self.costToChooseControl setSelectedSegmentIndex: [self loadPreviousSettingsWithKey:@"costToChoose" usingDefaultValue:0] + 1];

    // set both the stepper and the text fields to the correct previous settings
    self.matchBonusStepper.value = [self loadPreviousSettingsWithKey:@"matchBonus" usingDefaultValue:4];
    self.matchBonusTextField.text = [NSString stringWithFormat:@"%d", [self loadPreviousSettingsWithKey:@"matchBonus" usingDefaultValue:4]];
    
    self.mismatchPenaltyStepper.value = [self loadPreviousSettingsWithKey:@"mismatchPenalty" usingDefaultValue:-2];
    self.mismatchPenaltyTextField.text = [NSString stringWithFormat:@"%d", [self loadPreviousSettingsWithKey:@"mismatchPenalty" usingDefaultValue:-2]];
    
}

- (int) loadPreviousSettingsWithKey: (NSString *)key usingDefaultValue:(int)val{
        NSString *str =[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return str ? [str intValue] : val;
}

- (IBAction)touchDifficultyControl:(UISegmentedControl *)sender {
    
    [self updateUserDefaultsWithObject:[NSString stringWithFormat:@"%d",self.matchismoDifficultyControl.selectedSegmentIndex] withKey:@"difficulty"];
}

- (IBAction)touchCostToChooseControl:(UISegmentedControl *)sender {
    // index 0 = cost is -1, index 1 = cost is 0
    [self updateUserDefaultsWithObject:[NSString stringWithFormat:@"%d",self.costToChooseControl.selectedSegmentIndex - 1] withKey:@"costToChoose"];
}

- (IBAction)bonusValueChanged:(UIStepper*)sender {
    int value = [sender value];
    [self.matchBonusTextField setText:[NSString stringWithFormat:@"%d", (int)value]];
    [self updateUserDefaultsWithObject:self.matchBonusTextField.text withKey:@"matchBonus"];
    
}
- (IBAction)penaltyValueChanged:(UIStepper *)sender {
    int value = [sender value];
    [self.mismatchPenaltyTextField setText:[NSString stringWithFormat:@"%d", (int)value]];
    [self updateUserDefaultsWithObject:self.mismatchPenaltyTextField.text withKey:@"mismatchPenalty"];
}

- (void) updateUserDefaultsWithObject:(NSString *) val withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
