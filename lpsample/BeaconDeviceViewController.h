//
//  BeaconDeviceViewController.h
//
//  Copyright (c) 2014 spotlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPFBeaconObject;

@interface BeaconDeviceViewController : UIViewController

- (instancetype)initWithBeacon:(LPFBeaconObject *)beacon;

@end
