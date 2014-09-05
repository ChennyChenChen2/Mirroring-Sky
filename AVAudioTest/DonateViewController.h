//
//  DonateViewController.h
//  Mirroring Sky
//
//  Created by Jonathan Chen on 8/26/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface DonateViewController : UIViewController

@property (weak, nonatomic) IBOutlet CustomButton *donateButton;

- (IBAction)donateButtonPressed:(id)sender;

@end
