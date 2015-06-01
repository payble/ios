//
//  JsonRead.h
//  ituneUniversity
//
//  Created by Balvinder on 5/3/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JsonRead : NSObject {

}
-(NSMutableDictionary*)jsonReadSubjects:(NSString *)tmpUser;
-(NSString *)createJson:(id)tmpDict;
-(NSMutableDictionary*)jsonReadSubjectDetail:(NSString *)subjectId;
@end
