//
//  Singleton.h
//  FYRent
//
//  Created by yuanjianguo on 2017/7/7.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#undef	AS_SINGLETON
#define AS_SINGLETON \
    - (instancetype)sharedInstance; \
    + (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON \
    - (instancetype)sharedInstance \
    { \
        return [[self class] sharedInstance]; \
    } \
    + (instancetype)sharedInstance \
    { \
        static dispatch_once_t once; \
        static id __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
        return __singleton__; \
    }

#undef	DEF_SINGLETON_AUTOLOAD
#define DEF_SINGLETON_AUTOLOAD \
    DEF_SINGLETON \
    + (void)load \
    { \
        [self sharedInstance]; \
    }
