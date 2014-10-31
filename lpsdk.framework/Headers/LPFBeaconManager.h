// Light Platform for iBeacon apps
//
//  LPFBeaconManager.h
//
//  Copyright (c) 2014年 spotlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPFErrors.h"
#import "LPFBeaconObject.h"

typedef void (^LPFRegisterSuccessHandler)(BOOL wasVirginDevice, BOOL tokenChanged);
typedef void (^LPFRegisterErrorHandler)(LPFDeviceRegistError error);

typedef void (^LPFRequestCheckinSuccessHandler)(NSString *token, NSDictionary *metadata, NSString *beaconExternalId);
typedef void (^LPFRequestCheckinErrorHandler)(LPFRequestTokenError error);


// main delegate ------------------------------------------
@protocol LPFBeaconDelegate <NSObject>
@optional
- (BOOL)shouldReportErrorWithLatitude:(double *)latitude
                           longitude:(double *)longitude
                            accuracy:(double *)accuracy;
- (void)didFindiBeacon:(LPFBeaconObject *)beacon;
- (void)didFailMonitoringiBeacon:(BOOL)userDenied capability:(BOOL)capability;
@end

// region entered delegate (for use when app is backgrounded or killed)
// usually used with AppDelegate
@protocol LPFBeaconRegionDelegate <NSObject>
@optional
- (void)didEnterBeaconRegion;
- (void)didExitBeaconRegion;
@end

// beacon searching delegate ------------------------------
@protocol LPFBeaconSearchDelegate <NSObject>
@optional
- (void)willStartBeaconSearch;
- (void)didStartBeaconSearch;
- (void)didCancelBeaconSearch;

- (void)didDetectBeacon:(LPFBeaconObject *)beacon;
- (void)didBeaconChangePower:(double)power;
- (void)didFailDetectBeacon;
@end

@interface LPFBeaconManager : NSObject

// LPFBeaconManager initializer
// Basic required settings
+ (void)setAccessKey:(NSString *)accessKey
           secretKey:(NSString *)secretKey
      errorReporting:(BOOL)errorReporting
      beaconDelegate:(id<LPFBeaconDelegate>)beaconDelegate
      regionDelegate:(id<LPFBeaconRegionDelegate>)regionDelegate;

// Device Registration
+ (void)registerDeviceWithSuccessHandler:(LPFRegisterSuccessHandler)successHandler
                            errorHandler:(LPFRegisterErrorHandler)errorHandler;
+ (void)unregisterDevice;
+ (NSString *)deviceToken;

// Search Beacons
+ (void)startBeaconSearchWithDelegate:(id<LPFBeaconSearchDelegate>)delegate;
+ (void)stopBeaconSearch;

// Search iBeacons
+ (void)startiBeaconSearch;
+ (void)stopiBeaconSearch;

// Beacon Checkin + Metadata
+ (void)requestCheckinWithBeaconObject:(LPFBeaconObject *)beacon
                        successHandler:(LPFRequestCheckinSuccessHandler)successHandler
                          errorHandler:(LPFRequestCheckinErrorHandler)errorHandler;

// Debugging
+ (NSArray *)debugLogs;

@end
