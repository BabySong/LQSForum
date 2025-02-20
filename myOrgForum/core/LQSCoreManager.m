//
//  LQSCoreManager.m
//  myOrgForum
//
//  Created by SkyAndSea on 16/5/11.
//  Copyright © 2016年 SkyAndSea. All rights reserved.
//

#import "LQSCoreManager.h"

@implementation LQSCoreManager
const static NSObject *lockObj = nil;

+ (LQSCoreManager *)shareManager
{
    static LQSCoreManager *manager = nil;
    static dispatch_once_t singleDialogCachepredicate;
    dispatch_once(&singleDialogCachepredicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (lockObj == nil) {
            lockObj = [NSObject new];
        }
        @synchronized(lockObj){
            
        }
    }
    return self;
}

#pragma mark - discover

//视界
//- (void)httpRequestHorizonSuccess:(void (^)(id responseObject))success
//                          failure:(void (^)(NSError *error))failure
//{
//
//    LQSHorizonDataModel *param = [[LQSHorizonDataModel alloc] init];
//    
//    [self HttpsPost:kDiscoverUrl
//             params:param
//            success:success
//            failure:failure];
//
//}



#pragma mark - Http common 

- (void)HttpsPost:(NSString *)URLStr
           params:(id)params
          success:(void (^)(id))success
          failure:(void (^)(NSError *error))failure{

    if (!kNetworkIsReached) {
        kNetworkNotReachedMessage;
        if (failure) {
            NSError *_error = [[NSError alloc] initWithDomain:@"网络好像有点问题" code:1012 userInfo:nil];
            failure(_error);
        }
        return;
    }
    self.htttpRequestSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.htttpRequestSessionManager POST:URLStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}



- (AFHTTPSessionManager *)htttpRequestSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setSecurityPolicy:[self securityPolicy]];

    return manager;
}

- (AFSecurityPolicy *)securityPolicy
{

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    return securityPolicy;


}

@end
