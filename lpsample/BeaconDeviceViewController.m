//
//  BeaconDeviceViewController.m
//
//  Copyright (c) 2014 spotlight. All rights reserved.
//

#import <lpsdk/lpsdk.h>

#import "PureLayout.h"
#import "BeaconDeviceViewController.h"

@interface BeaconDeviceViewController ()
@property (nonatomic, strong) LPFBeaconObject *beacon;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSDictionary *metadata;

@end

@implementation BeaconDeviceViewController

- (instancetype)initWithBeacon:(LPFBeaconObject *)beacon {
    self = [super init];
    if (self) {
        self.beacon = beacon;
        self.textView = [UITextView newAutoLayoutView];
        self.textView.text = @"loading";
        self.textView.font = [UIFont systemFontOfSize:20];
        self.textView.editable = NO;

        [self.view addSubview:self.textView];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [LPFBeaconManager requestCheckinWithBeaconObject:self.beacon successHandler:^(NSString *token, NSDictionary *metadata, NSString *beaconExternalId) {
        NSLog(@"got token: %@", token);
        NSLog(@"got metadata: %@", metadata);

        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:metadata
                                                      options:NSJSONWritingPrettyPrinted
                                                        error:&error];
        if (error) {
            self.textView.text = @"error parsing metadata...";
        } else {
            self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        //self.dataLabel.text = token;
    } errorHandler:^(LPFRequestTokenError error) {
        NSLog(@"error requesting token: %ldu", error);
        self.textView.text = @"error";
    }];

}

- (void)setupConstraints {
    [self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


@end
