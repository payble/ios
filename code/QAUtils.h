//
//  QAUtils.h
//  quizApp
//
//  Created by Mac5 on 11/15/14.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface QAUtils : NSObject
+(BOOL)IsNetConnected;
+(void)showAlert:(NSString*)msg;
+(void)showAlert:(NSString*)msg delegate:(id)delegate btnOk:(NSString*)btnOk btnCancel:(NSString*)btnCancel;
+(BOOL)fileExistInDocumentDir:(NSString*)fileName;
+(NSString*)getDocumentDirPath;
void UCSaveSingleUserName(NSString *strEmailId);
void UCSaveSinglePassword(NSString *strPassword);
NSString *UCGetUserUname();
NSString *UCGetUserPassword();
void UCSaveDeletePassword();
@end
