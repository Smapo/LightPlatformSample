// Light Platform for iBeacon apps
//
//  LPFBeaconObject.h
//
//  Copyright (c) 2014年 spotlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPFBeaconObject : NSObject

// if True  --> is normal sound-type Beacon
// if False --> is iBeacon
@property (nonatomic, readonly) BOOL isSound;

// Sound-Type Beacon
@property (nonatomic, assign) NSString *beaconId;
@property (nonatomic, readonly) NSString *beaconHash;

//@property (nonatomic, strong) NSDate    *detectedDate;

// iBeacon
@property (nonatomic, readonly) NSUInteger major;
@property (nonatomic, readonly) NSUInteger minor;
@property (nonatomic, readonly) NSInteger rssi;


- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor rssi:(NSInteger)rssi;

- (void)customizeDetector:(id)object;
- (void)fillRequestObject:(id)object;

- (BOOL)isEqualToBeaconObject:(LPFBeaconObject *)object;

@end
