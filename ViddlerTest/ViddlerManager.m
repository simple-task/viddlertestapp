//
//  ViddlerManager.m
//  NiVo
//
//  Created by Milan Miletic on 7/23/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import "ViddlerManager.h"

#import "AFNetworking.h"
#import "URLProvider.h"

static const NSString *viddleAPIKey = @"1m1oyamfq81s9xbj0y6t";
static const NSString *viddlerUsername = @"mynivo";
static const NSString *viddlerPassword = @"nivo_admin";

@interface ViddlerManager()

@property (nonatomic) NSString *sessionId;

@end

@implementation ViddlerManager

- (void)login
{
    [self GetRequest:[NSString stringWithFormat:[URLProvider instance].ViddlerLoginURL, viddleAPIKey, viddlerUsername, viddlerPassword] withSuccess:^(id JSONResponse) {
        NSDictionary *item = [JSONResponse valueForKey:@"auth"];
        self.sessionId = [item valueForKey:@"sessionid"];
    } fail:^(NSError *error) {
        // LOG
    }];
}

- (void)postVideo:(NSURL*)url withSuccess:(void(^)(NSString*))successBlock
{
    [self GetRequest:[NSString stringWithFormat:[URLProvider instance].ViddlerPrepareUploadURL, viddleAPIKey, self.sessionId]
         withSuccess:^(id JSONResponse) {
             NSDictionary *json = [JSONResponse objectForKey:@"upload"];
             NSString *endpoint = [json objectForKey:@"endpoint"];
             NSString *token = [json objectForKey:@"token"];
    
             endpoint = [NSString stringWithFormat:@"%@?uploadtoken=%@", endpoint, token];
             
             NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:endpoint parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 [formData appendPartWithFileURL:url name:@"file" fileName:@"video.mov" mimeType:@"video/*" error:nil];
             } error:nil];
             
             AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
             NSProgress *progress = nil;
             
             NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
             {
                 if (error)
                 {
                    successBlock(@"Error while uploading video file to viddler.");
                 }
                 else
                 {
                     successBlock(@"Upload to viddler finished.");
                 }
             }];
             
             [uploadTask resume];
    } fail:^(NSError *error) {
        successBlock(@"Error while creating upload request to viddler.");
    }];
}

#pragma mark - Request

- (void)PostRequest:(NSString *)url
         withParams:(NSDictionary *)parameters withSuccess:(void(^)(id JSONResponse))successBlock fail:(void(^)(NSError *error))failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         successBlock(responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failBlock(error);
     }];
    
    successBlock(nil);
}

- (void)GetRequest:(NSString *)url withSuccess:(void(^)(id JSONResponse))successBlock fail:(void(^)(NSError *error))failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         successBlock(responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failBlock(error);
     }];
}

+ (ViddlerManager *)instance
{
    static ViddlerManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[ViddlerManager alloc] init];
        }
        
        return sharedSingleton;
    }
}

@end
