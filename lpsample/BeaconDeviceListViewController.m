//
//  BeaconDeviceViewController.m
//
//  Copyright (c) 2014 spotlight. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <lpsdk/lpsdk.h>
#import "PureLayout.h"

#import "BeaconDeviceViewController.h"
#import "BeaconDeviceListViewController.h"

@interface BeaconDeviceListViewController () <LPFBeaconDelegate, LPFBeaconSearchDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *beacons;
@property (nonatomic, strong) NSMutableSet *seenBeacons;
@end

NSString *const accessKey = @"717976392bb23c004d31a3b7648885d1102efa30";
NSString *const secretKey = @"214acc0a6ba47144266e7683cf4fb75d74d4adab";

@implementation BeaconDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"detect" style:UIBarButtonItemStylePlain target:self action:@selector(detect)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearBeacons)];

    [self clearBeacons];

    self.locationManager = [[CLLocationManager alloc] init];
    [self requestLocationPermission];
    [LPFBeaconManager setAccessKey:accessKey
                         secretKey:secretKey
                    errorReporting:NO
                    beaconDelegate:self
                    regionDelegate:(id<LPFBeaconRegionDelegate>)[[UIApplication sharedApplication] delegate]];
    NSLog(@"token %@", [LPFBeaconManager deviceToken]);

    if (![LPFBeaconManager deviceToken]) {
        [LPFBeaconManager registerDeviceWithSuccessHandler:^(BOOL wasVirginDevice, BOOL tokenChanged) {
            NSLog(@"register: successfully registered device firstTime:%d tokenChanged:%d", wasVirginDevice, tokenChanged);
        } errorHandler:^(LPFDeviceRegistError error) {
            NSLog(@"register: failed to register device: %ld", error);
        }];
    };

}

- (void)clearBeacons {
    self.seenBeacons = [NSMutableSet setWithCapacity:10];
    self.beacons = [NSMutableArray arrayWithCapacity:10];
    [self.tableView reloadData];
}

- (void)detect {
    [LPFBeaconManager startBeaconSearchWithDelegate:self];
}

- (void)requestLocationPermission {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    BOOL is8 = floor([UIDevice currentDevice].systemVersion.floatValue) >= 8.0;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"status: %d", status);
    switch (status) {
        default:
        case kCLAuthorizationStatusNotDetermined:
            if (is8) {
                NSLog(@"requesting always auth");
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorized:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [LPFBeaconManager startiBeaconSearch];
            break;
        case kCLAuthorizationStatusNotDetermined:
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    LPFBeaconObject *beacon = self.beacons[indexPath.row];

    if (beacon.isSound) {
        cell.textLabel.text = @"sound";
        cell.detailTextLabel.text = beacon.beaconHash;
    } else {
        cell.textLabel.text = @"ibeacon";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %ld, Minor:%ld", beacon.major, beacon.minor];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPFBeaconObject *beacon = self.beacons[indexPath.row];
    BeaconDeviceViewController *beaconViewController = [[BeaconDeviceViewController alloc] initWithBeacon:beacon];
    [self.navigationController pushViewController:beaconViewController animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (void)potentiallyAddBeacon:(LPFBeaconObject *)beacon {
    if ([self.seenBeacons containsObject:beacon]) {
        return;
    } else {
        [self.seenBeacons addObject:beacon];
        [self.beacons addObject:beacon];
        [self.tableView reloadData];
    }
}

// sound beacon delegate

- (void)didBeaconChangePower:(double)power {
    // NSLog(@"beacon changed power: %f", power);
}

- (void)didDetectBeacon:(LPFBeaconObject *)beacon {
    NSLog(@"found beacon: %@", beacon);
    [self potentiallyAddBeacon:beacon];
}

- (void)didFailDetectBeacon {
    NSLog(@"failed to detect beacon");
}

// ibeacon delegate

- (void)didFindiBeacon:(LPFBeaconObject *)beacon {
    // NSLog(@"found iBeacon  major:%ldu minor:%ldu signal:%ld", beacon.major, beacon.minor, beacon.rssi);
    [self potentiallyAddBeacon:beacon];
}

- (void)didFailMonitoringiBeacon:(BOOL)userDenied capability:(BOOL)capability {
    NSLog(@"failed monitoring beacon userdenied:%d capability:%d", userDenied, capability);
}

@end
