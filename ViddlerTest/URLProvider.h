//
//  AppDelegate.h
//  NiVo
//
//  Created by Milan Miletic on 7/12/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLProvider : NSObject

+ (URLProvider*)instance;

@property (readonly) NSString* GetAllCategoriesURL;
@property (readonly) NSString* GetSportCategoriesURL;
@property (readonly) NSString* NewPostURL;
@property (readonly) NSString* GetPostURL;
@property (readonly) NSString* GetPostsURL;
@property (readonly) NSString* FilterPostsURL;
@property (readonly) NSString* NewUserURL;
@property (readonly) NSString* GetUserURL;
@property (readonly) NSString* GetUserRatings;
@property (readonly) NSString* EditUserURL;
@property (readonly) NSString* GetCommentsURL;
@property (readonly) NSString* UploadMediaURL;
@property (readonly) NSString* GetFollowersURL;
@property (readonly) NSString* GetFollowingURL;
@property (readonly) NSString* FollowUserURL;
@property (readonly) NSString* UnfollowUserURL;
@property (readonly) NSString* GetVideoRatingURL;
@property (readonly) NSString* RateVideoURL;
@property (readonly) NSString* GetUserPointsURL;
@property (readonly) NSString* AddUserPointsURL;
@property (readonly) NSString* GetFacebookGraphURL;
@property (readonly) NSString* GetLoginUserURL;
@property (readonly) NSString* GetUserProfile;
@property (readonly) NSString* ViddlerLoginURL;
@property (readonly) NSString* ViddlerVideoDetailsURL;
@property (readonly) NSString* ViddlerPrepareUploadURL;
@property (readonly) NSString* GetLoginFacebookUser;
@property (readonly) NSString* GetLoginUserWithToken;
@property (readonly) NSString* GetAlertsForUser;
@property (readonly) NSString* GetPostsForLocation;
@property (readonly) NSString* GetVideosByRating;
@property (readonly) NSString* GetVideosByDate;
@property (readonly) NSString* NewCommentURL;
@property (readonly) NSString* DeleteUserURL;
@property (readonly) NSString* ReportVideoURL;
@property (readonly) NSString* ForgottenPaswordURL;
@property (readonly) NSString* ChangePaswordURL;
@property (readonly) NSString* GetSettingsURL;

@end
