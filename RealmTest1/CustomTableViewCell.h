//
//  CustomTableViewCell.h
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCell;

@property (strong, nonatomic) IBOutlet UILabel *imageTitleCell;
@property (strong, nonatomic) IBOutlet UILabel *imageDateDell;

@end
