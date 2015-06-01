//
//  upScale.h
//  kentApp
//
//  Created by pericent on 12/24/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpSacleCell.h"


@interface upScale : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
 
    
    
   IBOutlet UpSacleCell *cell;
    
}

@property(nonatomic,weak)NSArray *arrListOfRestaurent;

@end
