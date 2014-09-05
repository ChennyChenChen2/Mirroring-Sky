//
//  AVAudMapViewViewController.m
//  AVAudioTest
//
//  Created by Jonathan Chen on 8/1/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "AVAudMapViewController.h"

@interface AVAudMapViewController ()

@end

@implementation AVAudMapViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.detectRegion = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:7.0f target:self selector:@selector(changeDetectRegionStatus) userInfo:nil repeats:YES];
    
    [self.tabBarController.viewControllers makeObjectsPerformSelector:@selector(view)];
    self.playerViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    self.trackUser = YES;
    [self.zoomButton setBackgroundImage:[UIImage imageNamed:@"MapLocationIcon.gif"] forState:UIControlStateNormal];
    
    self.regions = [[NSMutableArray alloc] init];
    [self generateRegionsFromPlist:@"Philly"]; // Change to whichever map is being used
    
    self.currentRegion = [self getUserCurrentRegion]; // nil if we start outside of regions
    if (self.currentRegion == nil) {
        [self.playerViewController.titleLabel setText:@""];
        self.playerViewController.currentPlayer = self.playerViewController.backgroundPlayer;
    } else {
        [self.playerViewController.titleLabel setText:self.currentRegion.name];
        self.playerViewController.currentPlayer = self.currentRegion.player;
    }
    [self.playerViewController.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.playerViewController.currentPlayer play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add lines, regions, and music files to arrays via the plist
- (void)generateRegionsFromPlist:(NSString *)filename {
    [self addLines];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSString *namesPath = [[NSBundle mainBundle] pathForResource:@"Titles" ofType:@"plist"];
    
    NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *names = [NSArray arrayWithContentsOfFile:namesPath];
    NSArray *regionPoints = properties[@"regions"];
    NSArray *musicFiles = properties[@"music"];
    
    for(int i = 0; i < regionPoints.count; i++) {
        NSArray *a = [NSArray arrayWithArray:regionPoints[i]];
        NSString *file = musicFiles[i];
        AVAudViewController *vc = [self.tabBarController.viewControllers objectAtIndex:1];
        Region *r = [[Region alloc] initWithPoints:a name:names[i] Controller:vc identifier:i andFile:file];
        [self.regions addObject:r];
        [self addRegion:r];
    }
}

// Handles zooming to user's location initially, as well as determining the next player to play
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // One-time operation: zoom to user's location when user's location initially updates
    if (self.trackUser) {
        [self zoomToUserLocation];
        self.trackUser = NO;
    }
    if (self.detectRegion) {
        Region *region = [self getUserCurrentRegion]; // could be nil because we are not in a region
        switch ([self regionDidChange:region]) {
            case 1: // Out of region
                // NSLog(@"");
                // Do we need to do anything here??
                break;
            case 2:                                 // Out of region -> in region
                [self.playerViewController fadeOutAndResetPlayer];
                [self.playerViewController deallocPlayer];
                [region initPlayer];
                self.playerViewController.currentPlayer = region.player;
                self.playerViewController.titleLabel.text = region.name;
                [self.playerViewController.currentPlayer play];
                [self.playerViewController.playButton setTitle:@"Pause" forState:UIControlStateNormal];
                break;
            case 3:  // In region
                //NSLog(@"");
                // Do we need to do anything here?
                break;
            case 4:                                 // In region -> out of region
                // We can perform checking here to see if we have passed out of regions in which
                // the pulses get quicker and change the contents of the background player
                [self.playerViewController fadeOutAndResetPlayer];
                [self.playerViewController initPlayer];
                self.playerViewController.currentPlayer = self.playerViewController.backgroundPlayer;
                [self.playerViewController.playButton setTitle:@"Pause" forState:UIControlStateNormal];
                self.playerViewController.titleLabel.text = @"";
                [self.playerViewController.currentPlayer play];
                [region deallocPlayer];
                break;
        }
    }
}

- (void) changeDetectRegionStatus {
    if (self.detectRegion) {
        self.detectRegion = NO;
    } else {
        self.detectRegion = YES;
    }
}

// Pass back a flag about whether the region did change, which we can tell by whether the name of the
// first region is the same as the name of the new region.
// We assume that no two regions are consecutive, so whenever we leave a region, we set the
// self.currentRegion pointer to nil.
- (int)regionDidChange:(Region *)region {
    // Was not in region before, and is still not
    if (self.currentRegion == nil && region == nil) {
        return 1;
    }
    // Was not in region, but now is, so we have a new curent region
    else if (self.currentRegion == nil && region != nil) {
        self.currentRegion = region;
        return 2;
    }
    // Was in region before and still is
    if ([self.currentRegion.name isEqualToString:region.name]) {
        return 3;
    }
    // Was in region, and now isn't
    else {
        self.currentRegion = nil;
        return 4;
    }
}

// Return the current region
- (Region *)getUserCurrentRegion {
    for (Region *r in self.regions) {
        if ([self userIsInRegion:r]) {
            return r;
        }
    }
    return nil;
}

// Zoom to current location
- (void)zoomToUserLocation {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 400, 400);
    [_mapView setRegion:region animated:YES];
}

// Map zoom button action
- (IBAction)zoomIn:(id)sender {
    [self zoomToUserLocation];
}

// Change map between standard, hybrid, or satellite
- (IBAction)changeMapType:(id)sender {
    switch (self.typeController.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

// Add polygons to map
// Points are defined in Ashburn.plist
- (void)addRegion:(Region *) region {
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:region.boundary
                                                     count:region.boundaryPointsCount];
    [self.mapView addOverlay:polygon];
}

// Add lines to map
// Points are defined in Ashburn.plist
- (void)addLines {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"PhillyRoutes" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.mapView addOverlay:myPolyline];
}

// Specifies the renderer to be drawn when map realizes an overlay is in view
// Use this to handle all kinds of overlays. Polyline, Polygon
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
     if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        return lineView;
    } else if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolygon *polygon = (MKPolygon*) overlay;
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        MKMapPoint *points = polygon.points;
        // Find which region represents the MKPolygon
        for (Region *r in self.regions) {
            BOOL regionSame = YES;
            CLLocationCoordinate2D *rPoints = r.boundary;
            // Compare region's points with polygon's points
            for (int i = 0; i < r.boundaryPointsCount; i++) {
                MKMapPoint p1 = MKMapPointForCoordinate(rPoints[i]);
                MKMapPoint p2 = MKMapPointMake(points[i].x, points[i].y);
                if (p1.x != p2.x || p1.y != p2.y) {
                    regionSame = NO;
                }
            }
            if (regionSame && ([r.name isEqualToString:@"Rittenhouse Square"] || [r.name isEqualToString:@"Fitler Square"] || [r.name isEqualToString:@"Schuylkill River Park"])) {
                polygonView.strokeColor = [UIColor blackColor];
                return polygonView;
            }
        }
        polygonView.strokeColor = [UIColor clearColor];
        return polygonView;
    }
    
    return nil;
}

// Return whether or not user is in a region
// Taken from http://www.ecse.rpi.edu/~wrf/Research/Short_Notes/pnpoly.html
- (BOOL)userIsInRegion:(Region *)region {
        int i, j, c = 0;
        CLLocationCoordinate2D coord = self.mapView.userLocation.coordinate;
        for (i = 0, j = region.boundaryPointsCount-1; i < region.boundaryPointsCount; j = i++) {
            if ((region.boundary[i].latitude > coord.latitude) !=
                (region.boundary[j].latitude > coord.latitude) &&
                (coord.longitude < (region.boundary[j].longitude-region.boundary[i].longitude) * (coord.latitude-region.boundary[i].latitude) / (region.boundary[j].latitude-region.boundary[i].latitude) + region.boundary[i].longitude) )
                c = !c;
        }
    return c;
}

@end