//
//  AshburnMap.m
//  MirroringSky
//
//  Created by Jonathan Chen on 8/15/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "Region.h"

@implementation Region

- (instancetype)initWithPoints:(NSArray *)points name:(NSString *)name Controller:(AVAudViewController *)controller identifier:(int)rId andFile:(NSString *)file {
    self = [super init];
    if (self) {
        self.regionId = rId;
        self.file = file;
        self.name = name;
        self.controller = controller;
        [self initPlayer];
        _boundaryPointsCount = points.count;
        _boundary = malloc(sizeof(CLLocationCoordinate2D)*_boundaryPointsCount);
        
        for(int i = 0; i < _boundaryPointsCount; i++) {
            CGPoint p = CGPointFromString(points[i]);
            _boundary[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
    }
    return self;
}

- (void)initPlayer {
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.file
                                                         ofType:@"mp3"];
    NSURL* musicURL = [NSURL fileURLWithPath:filePath];
    NSData *songFile = [[NSData alloc] initWithContentsOfURL:musicURL options:NSDataReadingMappedIfSafe error:&error];
    self.player = [[AVAudioPlayer alloc] initWithData:songFile error:&error];
    self.player.delegate = self.controller;
}

- (void)deallocPlayer {
    self.player = nil;
}



@end
