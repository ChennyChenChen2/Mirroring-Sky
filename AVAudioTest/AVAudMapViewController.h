//
//  AVAudMapViewViewController.h
//  AVAudioTest
//
//  Created by Jonathan Chen on 8/1/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Region.h"
#import "AVAudViewController.h"

@interface AVAudMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeController;
@property (strong, nonatomic) Region *currentRegion;
@property (strong, nonatomic) NSMutableArray *regions;
@property BOOL trackUser;
@property BOOL detectRegion;
@property (strong, nonatomic) AVAudViewController *playerViewController;
@property (strong, nonatomic) NSTimer *timer;

- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end
