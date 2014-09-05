//
//  AshburnMap.h
//  MirroringSky
//
//  Created by Jonathan Chen on 8/15/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AVAudViewController.h"
@import AVFoundation;

@interface Region : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D *boundary;
@property (nonatomic, readonly) NSInteger boundaryPointsCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) AVAudViewController *controller;
@property int regionId;

- (instancetype)initWithPoints:(NSArray *)points name:(NSString *)name Controller:(AVAudViewController *)controller identifier:(int)rId andFile:(NSString *) file;
- (void)initPlayer;
- (void)deallocPlayer;

@end
