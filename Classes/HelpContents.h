//
//  HelpContents.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Help.h"


@interface HelpContents : UIViewController {
	UITableView *groupedTable;
	Help *help;

	UIImageView *background;
}

@property (nonatomic, retain) IBOutlet UITableView *groupedTable;
@property (nonatomic, retain) IBOutlet Help *help;

@property (nonatomic, retain) IBOutlet UIImageView *background;

-(void)helpPage:(int)newPage;

@end
