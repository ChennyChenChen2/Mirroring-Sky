//
//  AVAudViewController.h
//  AVAudioTest
//
//  Created by Jonathan Chen on 7/26/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface AVAudViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, atomic) AVAudioPlayer *backgroundPlayer;
@property (strong, atomic) AVAudioPlayer *currentPlayer;

- (void)initProperties;
- (void)fadeOutAndResetPlayer;
-(IBAction)playButtonPressed:(id)sender;
-(IBAction)stopButtonPressed:(id)sender;
-(IBAction)volumeSliderChanged:(id)sender;
-(void)initPlayer;
-(void)deallocPlayer;

@end
