//
//  QARestIntraction.h
//  quizApp
//
//  Created by Mac5 on 11/17/14.
//
//

#import <Foundation/Foundation.h>
#import "QAConstant.h"
#import "QAUtils.h"
#import "ASIFormDataRequest.h"
#import "DSActivityView.h"
@interface QARestIntraction : NSObject
+(void)GetDataForMethod:(NSDictionary *)dicOfParameters strMethod:(NSString *)strMethod authentication:(BOOL)Header withCompletion:(void (^)(id data))completion WithFailure:(void (^)(NSString *error))failure;
@end
