//
//  AVAudViewController.m
//  AVAudioTest
//
//  Created by Jonathan Chen on 7/26/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "AVAudViewController.h"
#import "AVAudMapViewController.h"
@import AVFoundation;

@interface AVAudViewController ()

@end

@implementation AVAudViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
#warning to set title, need to give each region an id property, and assign the correct id with the correct title
    
//    self.volumeSlider.maximumValue = 1;
//    
    
    //Enable background audio
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self initPlayer];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)initPlayer {
    NSError *error;
    
    // Need to provide path relative to the app bundle
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"transition1"
                                                         ofType:@"mp3"];
    
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:filePath];
    NSData *songFile = [[NSData alloc] initWithContentsOfURL:backgroundMusicURL options:NSDataReadingMappedIfSafe error:&error];
    
    self.backgroundPlayer = [[AVAudioPlayer alloc] initWithData:songFile error:&error];
    self.backgroundPlayer.delegate = self;
    self.backgroundPlayer.numberOfLoops = 10000;
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    }
    
    // If everything goes smoothly, set currentPlayer here and prepare to play
    else {
        self.currentPlayer = self.backgroundPlayer;
        NSLog([[NSNumber numberWithFloat:self.currentPlayer.duration] stringValue]);
        [self.currentPlayer prepareToPlay];
    }
}

-(void)deallocPlayer {
    self.backgroundPlayer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)playButtonPressed:(id)sender {
    if (self.currentPlayer.isPlaying) {
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.currentPlayer stop];
    }
    else {
        //NSLog(@" %s", self.currentPlayer.isPlaying ? "true" : "false");
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.currentPlayer play];
    }
}

-(IBAction)stopButtonPressed:(id)sender {
    [self.currentPlayer stop];
    self.currentPlayer.currentTime = 0;
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

-(IBAction)volumeSliderChanged:(id)sender {
    self.currentPlayer.volume = self.volumeSlider.value;
    //NSLog([NSString stringWithFormat:@"Slider value is: %f. Volume is: %f", self.volumeSlider.value, self.currentPlayer.volume]);
}

-(void)fadeOutAndResetPlayer {
    while (self.currentPlayer.volume > 0) {
        NSLog([[NSNumber numberWithFloat:self.currentPlayer.volume] stringValue]);
        // FADE-OUT RATE: 0.0000005 for simulator, 0.00035 for iPhone
        self.currentPlayer.volume -= 0.00035;
    }
    [self.currentPlayer stop];
    self.currentPlayer.currentTime = 0;
    self.currentPlayer.volume = self.volumeSlider.value;
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) flag {
    if (flag==YES) {
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        self.currentPlayer.currentTime = 0;
        AVAudMapViewController *mapViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        if ([mapViewController.currentRegion.name isEqualToString:@"Schuylkill River Park"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You have completed Mirroring Sky" message:@"Thank you for participating in Mirroring Sky. Feel free to restart the app to experience sounds you may have missed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            mapViewController.trackUser = YES;
            self.currentPlayer = nil;
            [self deallocPlayer];
            [self performSegueWithIdentifier:@"restart" sender:self];
            
        }
    }
}

@end
