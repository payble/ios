//
//  JsonRead.m
//  ituneUniversity
//
//  Created by Balvinder on 5/3/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import "JsonRead.h"
#import "JSON.h"

@implementation JsonRead

-(NSMutableDictionary*)jsonReadSubjects:(NSString *)tmpUser{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *docDirPath = [paths objectAtIndex:0];
	NSString *filePath=[docDirPath stringByAppendingFormat:@"/%@_subjects.txt",tmpUser];
	NSString *storedStr=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	
	SBJSON *jsonparser=[[[SBJSON alloc]init] autorelease];
	
	NSMutableDictionary *userDict=[jsonparser objectWithString:storedStr error:&error];
	
	return userDict;
} 


-(NSString *)createJson:(id)tmpDict{

	return [tmpDict JSONRepresentation];
}



-(NSMutableDictionary*)jsonReadSubjectDetail:(NSString *)subjectId{
	NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
	NSString *userName=[prefs objectForKey:@"userName"];
	[prefs synchronize];
	
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *docDirPath = [paths objectAtIndex:0];
	NSString *subjectFolder=[NSString stringWithFormat:@"%@_subjects",userName];
	NSString *subjectFolderPath=[docDirPath stringByAppendingPathComponent:subjectFolder];
	NSString *filePath=[subjectFolderPath stringByAppendingFormat:@"/%@_subjects.txt",userName];
	NSString *storedStr=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	
	SBJSON *jsonparser=[[[SBJSON alloc]init] autorelease];
	
	NSMutableDictionary *userDict=[jsonparser objectWithString:storedStr error:&error];
	
	return [userDict objectForKey:subjectId];
	
}

@end
