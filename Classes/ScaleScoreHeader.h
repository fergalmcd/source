//
//  ScaleScoreHeader.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScaleScoreHeader : UIView {
	IBOutlet UIButton		*headerDate;
	IBOutlet UIButton		*headerName;
	IBOutlet UIButton		*headerScore;

	IBOutlet UIImageView	*header;
	IBOutlet UIImageView	*divider1;
	IBOutlet UIImageView	*divider2;
	IBOutlet UIImageView	*dateSortArrow;
	IBOutlet UIImageView	*nameSortArrow;
	IBOutlet UIImageView	*scoreSortArrow;
}

@property (nonatomic, retain) UIButton *headerDate;
@property (nonatomic, retain) UIButton *headerName;
@property (nonatomic, retain) UIButton *headerScore;

@property (nonatomic, retain) UIImageView *header;
@property (nonatomic, retain) UIImageView *divider1;
@property (nonatomic, retain) UIImageView *divider2;
@property (nonatomic, retain) UIImageView *dateSortArrow;
@property (nonatomic, retain) UIImageView *nameSortArrow;
@property (nonatomic, retain) UIImageView *scoreSortArrow;

-(void)go;

@end
