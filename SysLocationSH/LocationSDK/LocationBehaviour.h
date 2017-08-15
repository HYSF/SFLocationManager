//
//  LocationBehaviour.h
//  FYRent
//
//  Created by yuanjianguo on 2017/7/7.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^LocationResult)(BOOL isSuccess,id result);

@interface LocationBehaviour : NSObject

AS_SINGLETON
@property (nonatomic, assign)BOOL shouldRefreshLocations;

- (void)startLocationWithLocationResult:(LocationResult)result;

@end
