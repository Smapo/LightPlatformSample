
# Light Platform SDK (*beta Release* for Rakuten Hakathon)

This repository includes the Light Platform SDK (lpsdk.framework) as well as sample project. lpsdk.framework is a universal binary, meaning it will run on both the simulator and your iphone device.  However, it uses bluetooth (for ibeacon) and the microphone (for the 超音波 device) so you will need an iphone to enjoy the full functionality of the SDK.

## Introduction and Hardware

Light Platform is a combination of an API service, an SDK (currently for iOS), and signal-emitting beacon hardware. There are currently two types of beacon hardware that we have created.

Both types of hardware are used to alert smartphones to their presence.  They emit unique signals that change over time, making spoofing signals impossible.

1. iBeacon.  This device conforms to the iBeacon protocol created by Apple. Each iBeacon emits a UUID, a major ID, and a minor ID. The UUID is the same for all of our hardware, but major/minor are not only different for each device, they change over time. When the SDK picks up on a major/minor ID, you can ask the API server for information about that beacon.

2. 超音波 Beacon. Emits a unique sound signal (roughly 18khz) that the SDK can detect through the iphone's microphone.

We will distribute 5 of each type for the Hakathon.

## Developer Account

To begin, register for a developer account at [lightpf.com](https://lightpf.com)  Log in and check your sdk access key and secret key.  They are located in the Profile section of the [admin dashboard](https://lightpf.com/admin/#/profile).

## Project preparation

In your .plist file make sure to include the following keys.

```
NSLocationAlwaysUsageDescription

NSLocationWhenInUseUsageDescription
```

To import the SDK, click on your target in Xcode and in the general tab there should be a section called `Embedded Binaries`. Drag and drop the lpsdk.framework file into it.

Note: In your application's code, be sure to ask for location permission and local push permission.

## Usage

Import the framework

```objective-c
#import <lpsdk/lpsdk.h>
```

Initialize the SDK

```objective-c
+ (void)setAccessKey:(NSString *)accessKey
           secretKey:(NSString *)secretKey
      errorReporting:(BOOL)errorReporting
      beaconDelegate:(id<LPFBeaconDelegate>)beaconDelegate
      regionDelegate:(id<LPFBeaconRegionDelegate>)regionDelegate;
```

The accessKey and secretKey are available in the admin dashboard. Specify 2 delegates (they can be the same class if you want).

#### Register User Device

The following method registers the user's device with the Light Platform API server. If there was an error, the errorHandler will tell you why it failed (perhaps you did not enter the secret/access keys correctly?).

```objective-c
+ (void)registerDeviceWithSuccessHandler:(LPFRegisterSuccessHandler)successHandler
                            errorHandler:(LPFRegisterErrorHandler)errorHandler;
```

#### beaconDelegate

The beaconDelegate, conforming to LPFBeaconDelegate protocol, receives callbacks when an iBeacon is found or when the SDK failed to find an ibeacon, perhaps due to not having Location permission or not having iBeacon capability (ex: old iphones)

To start searching for iBeacons:

```objective-c
+ (void)startiBeaconSearch;
```

#### regionDelegate

The regionDelegate is usually set to the AppDelegate. It receives callbacks when entering or exiting an area with 1 or more beacons. When backgrounded (or killed) you can, for instance, display local notifications to the user that they have entered an area with beacons.

#### 超音波 device detection.

For iBeacon, you can search almost continuously. However, for the 超音波 device, when you search, the SDK listens through the mic for <10 seconds and if it detects a beacon calls didDetectBeacon:(LPFBeaconObject *)beacon on your delegate;

To start searching:

```objective-c
// Search Beacons
+ (void)startBeaconSearchWithDelegate:(id<LPFBeaconSearchDelegate>)delegate;
```

#### 'Checking-in' and getting beacon metadata stored server-side

When you detect a beacon, you can check in to the API server and receive metadata which is an NSDictionary that matches the JSON you inputted on the server (see below).

```objective-c
+ (void)requestCheckinWithBeaconObject:(LPFBeaconObject *)beacon
                        successHandler:(LPFRequestCheckinSuccessHandler)successHandler
                          errorHandler:(LPFRequestCheckinErrorHandler)errorHandler;
```


## Adding beacon metadata

On the [admin dashboard beacons tab](https://lightpf.com/admin/#/beacons) you can add JSON metadata to each beacon.  This is the metadata that you receive when requesting a check-in.
