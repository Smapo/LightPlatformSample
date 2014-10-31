// Light Platform for iBeacon apps
//
//  LPFErrors.h
//
//  Copyright (c) 2014年 spotlight. All rights reserved.
//


typedef NS_ENUM(NSInteger, LPFDeviceRegistError) {
    LPFDeviceRegistErrorNoError = 0,

    // deeps
    LPFDeviceRegistErrorSDKError,

    // network related errors
    LPFDeviceRegistErrorNoNetwork,
    LPFDeviceRegistErrorSmapoDown,
    LPFDeviceRegistErrorSmapoInMaintainance,

    // request errors
    LPFDeviceRegistErrorInvalidAccessKey,

    // user relation
    LPFDeviceRegistErrorUserDisabled,
    LPFDeviceRegistErrorCurrenttimeIsInvalid
};

typedef NS_ENUM(NSInteger, LPFRequestTokenError) {
    LPFRequestTokenErrorNoError = 0,
    
    // deeps
    LPFRequestTokenErrorSDKError,

    // network related errors
    LPFRequestTokenErrorNoNetwork,
    LPFRequestTokenErrorSmapoDown,
    LPFRequestTokenErrorSmapoInMaintainance,

    // request errors
    LPFRequestTokenErrorInvalidAccessKey,
    LPFRequestTokenErrorInvalidBeacon,
    LPFRequestTokenErrorDeviceInvalidatedForYou,
    LPFRequestTokenErrorOverhasty,
    LPFRequestTokenErrorTooOldBeacon,

    LPFRequestTokenErrorNoUser,
    LPFRequestTokenErrorCurrenttimeIsInvalid
};
