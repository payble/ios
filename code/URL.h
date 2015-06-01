//
//  URL.h
//  GameDeal
//
//  Created by promatics on 7/4/14.
//  Copyright (c) 2014 myOffice. All rights reserved.
//

#ifndef GameDeal_URL_h
#define GameDeal_URL_h

#define baseURL @"http://netleondev.com/kentapi/user/"

#define imageURL @"%@updateUserImage",baseURL

#define base64KEY @"base64"
#define userIDKEY @"user_id"
#define imageNameKEY @"ImageName"



//http://netleondev.com/kentapi/user/addusercards

#define addUserCardURL @"%@addusercards",baseURL
#define user_idKEY @"user_id"
#define card_idKEY @"card_id"
#define cc_typeKEY @"cc_type"
#define cc_nameKEY @"cc_name"
#define cc_numberKEY @"cc_number"
#define cc_expiration_monthKEY @"cc_expiration_month"
#define cc_expiration_yearKEY @"cc_expiration_year"
#define is_defaultKEY @"is_default"





#define Post_Type @"POST"
#define Get_type @"GET"
#define Put_type @"PUT"

#endif
