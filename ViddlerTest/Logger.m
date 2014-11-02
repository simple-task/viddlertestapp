//
//  Logger.m
//  NiVo
//
//  Created by Milan Miletic on 10/23/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import "Logger.h"

static const int kLogFileSize = 100000;

static NSString *kCurrentLogfile = @"currentLogfile";
static const int kNumberOfFiles = 3;

static NSDateFormatter *dateFormatter = nil;
static NSFileHandle *fileHandle[kNumberOfFiles];
static unsigned long long fileSize = 0;
static int currentLogfile;

@implementation Logger

+ (void)startLogging
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    currentLogfile = (int)[standardUserDefaults integerForKey:kCurrentLogfile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    for(int count = 0; count < kNumberOfFiles; count++)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/nivolog_%d.log", libraryDirectory, count];
        
        if (![fileManager fileExistsAtPath:fileName])
        {
            [fileManager createFileAtPath:fileName contents:nil attributes:nil];
        }
        
        fileHandle[count] = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        if(count == currentLogfile)    // for the current logfile
        {
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:fileName error:nil];
            if(attributes != nil)
            {
                fileSize = [attributes fileSize];
            }
            
            [fileHandle[count] seekToEndOfFile];
        }
    }
}

+ (void)finishLogging
{
    [fileHandle[currentLogfile] synchronizeFile];
}

+ (void)logMessage:(NSString *)message
{
    NSDate *date = [NSDate date];
    NSString *messsageWithDate = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:date], message];
    [fileHandle[currentLogfile] writeData:[messsageWithDate dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle[currentLogfile] writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    fileSize += [messsageWithDate length] + 1;
    
    if(fileSize > kLogFileSize)
    {
        [fileHandle[currentLogfile] synchronizeFile];
        
        currentLogfile++;
        if(currentLogfile >= kNumberOfFiles)
        {
            currentLogfile = 0;
        }
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setInteger:currentLogfile forKey:kCurrentLogfile];
        [standardUserDefaults synchronize];
        
        [fileHandle[currentLogfile] truncateFileAtOffset:0];
        [fileHandle[currentLogfile] seekToEndOfFile];
        [fileHandle[currentLogfile] synchronizeFile];
        fileSize = 0;
    }
}

+ (void)log:(const char *)function line:(int)line string:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString *wholeMessage = [NSString stringWithFormat:@"%s %d: %@",function,line,message];
    [Logger logMessage:wholeMessage];
}

@end
