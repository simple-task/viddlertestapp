//
//  AppDelegate.h
//  NiVo
//
//  Created by Milan Miletic on 7/12/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import "URLProvider.h"

@interface URLProvider()

@property (nonatomic) NSDictionary *urlDictionary;
@property (nonatomic) NSDictionary *viddlerUrlDictionary;
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *baseSettingsURL;
@property (nonatomic) NSString *facebookGraphURL;
@property (nonatomic) NSString *viddlerBaseUrl;

@end

@implementation URLProvider

- (void)initializeSharedInstance
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* urlPListPath = [bundle pathForResource:@"BackendCalls" ofType:@"plist"];
    self.urlDictionary =  [[NSDictionary alloc] initWithContentsOfFile:urlPListPath];
    self.baseUrl = [self.urlDictionary valueForKey:@"baseURL"];
    self.baseSettingsURL = [self.urlDictionary valueForKey:@"settingsURL"];
    self.viddlerBaseUrl = [self.urlDictionary valueForKey:@"viddlerBaseURL"];
    self.facebookGraphURL = [self.urlDictionary valueForKey:@"facebookGraphURL"];
    self.viddlerUrlDictionary = [self.urlDictionary valueForKey:@"viddlerUrls"];
    self.urlDictionary = [self.urlDictionary objectForKey:@"urls"];
}

+ (URLProvider *)instance
{
    static URLProvider *sharedSingleton;
    
    @synchronized(self)
    {
        if (sharedSingleton == nil)
        {
            sharedSingleton = [[URLProvider alloc] init];
            [sharedSingleton initializeSharedInstance];
        }
        
        return sharedSingleton;
    }
}

- (NSString*)GetAllCategoriesURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getAllCategories"]];
}

- (NSString*)NewPostURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"newPost"]];
}

- (NSString*)GetPostURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getPost"]];
}

- (NSString*)GetPostsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getPosts"]];
}

- (NSString*)FilterPostsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"filterPosts"]];
}

- (NSString*)NewUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"newUser"]];
}

- (NSString*)GetUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getUser"]];
}

- (NSString*)GetFacebookGraphURL
{
    return self.facebookGraphURL;
}

- (NSString*)EditUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"editUser"]];
}

- (NSString*)GetCommentsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getComments"]];
}

- (NSString*)UploadMediaURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"uploadMedia"]];
}

- (NSString*)GetFollowersURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getFollowers"]];
}

- (NSString*)GetFollowingURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getFollowing"]];
}

- (NSString*)FollowUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"followUser"]];
}

- (NSString*)UnfollowUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"unfollowUser"]];
}

- (NSString*)GetVideoRatingURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getVideoRating"]];
}

- (NSString*)RateVideoURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"rateVideo"]];
}

- (NSString*)GetUserPointsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getUserPoints"]];
}

- (NSString*)AddUserPointsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"addUserPoints"]];
}

- (NSString *)GetLoginUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"loginUser"]];
}

- (NSString *)ViddlerLoginURL
{
    return [NSString stringWithFormat:@"%@%@", self.viddlerBaseUrl, [self.viddlerUrlDictionary valueForKey:@"login"]];
}

- (NSString *)ViddlerVideoDetailsURL
{
    return [NSString stringWithFormat:@"%@%@", self.viddlerBaseUrl, [self.viddlerUrlDictionary valueForKey:@"videoDetails"]];
}

- (NSString *)ViddlerPrepareUploadURL
{
    return [NSString stringWithFormat:@"%@%@", self.viddlerBaseUrl, [self.viddlerUrlDictionary valueForKey:@"prepareUpload"]];
}

- (NSString*) GetUserProfile
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getUserProfile"]];
}

- (NSString *) GetLoginFacebookUser
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"loginFacebookUser"]];
}

- (NSString *) GetLoginUserWithToken
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"loginUserWithToken"]];
}

- (NSString *) GetAlertsForUser
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getAlerts"]];
}

- (NSString *) GetPostsForLocation
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getPostsForLocation"]];
}

- (NSString*)GetVideosByRating
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getVideosByRate"]];
}

- (NSString*)GetVideosByDate
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getVideosByDate"]];   
}

- (NSString*)NewCommentURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"newComment"]];
}

- (NSString*)GetUserRatings
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getUserRatings"]];
}

-(NSString*) GetSportCategoriesURL;
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"getSportCategories"]];
}

-(NSString *) DeleteUserURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"deleteUser"]];
}

-(NSString *)ReportVideoURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"reportVideo"]];
}

-(NSString *)ForgottenPaswordURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"forgotPassword"]];
}

-(NSString *)ChangePaswordURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseUrl, [self.urlDictionary valueForKey:@"changePassword"]];
}

-(NSString *)GetSettingsURL
{
    return [NSString stringWithFormat:@"%@%@", self.baseSettingsURL, [self.urlDictionary valueForKey:@"settings"]];
}

@end
