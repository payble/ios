//
//  QAUtils.m
//  quizApp
//
//  Created by Mac5 on 11/15/14.
//
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QAUtils.h"

@implementation QAUtils

+(BOOL)IsNetConnected{
    BOOL isOk = YES;
    //// Where you need it
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Network connection unavailable"   message:@"You require an internet connection via WiFi or cellular network to use this application."
                                delegate:nil
                                cancelButtonTitle:@"Close"
                                otherButtonTitles:nil];
        [myAlert show];
        isOk = NO;
    }
    return isOk;
}

+(void)showAlert:(NSString*)msg{
    
    [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}
+(void)showAlert:(NSString*)msg delegate:(id)delegate btnOk:(NSString*)btnOk btnCancel:(NSString*)btnCancel
{
    
    [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:delegate cancelButtonTitle:btnCancel otherButtonTitles:btnOk,nil]show];
}
void UCSaveSingleUserName(NSString *strId){
    [[NSUserDefaults standardUserDefaults] setObject:strId forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
void UCSaveSinglePassword(NSString *strId){
    [[NSUserDefaults standardUserDefaults] setObject:strId forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
NSString *UCGetUserUname(){
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
}
NSString *UCGetUserPassword(){
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
}
void UCSaveDeletePassword(){
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
}

+(BOOL)fileExistInDocumentDir:(NSString*)fileName{
    
    NSString *documentsDirectory = [self getDocumentDirPath];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager new];
    BOOL fileExist = [fileManager fileExistsAtPath:filePath isDirectory:NO];
    return fileExist;
}

+(NSString*)getDocumentDirPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
