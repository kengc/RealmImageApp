//
//  AddViewController.h
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@protocol AddViewControllerProtocol <NSObject>

-(void)reloadTable;

@end

@interface AddViewController : UIViewController

@property (weak, nonatomic) id<AddViewControllerProtocol> delegate;

@property (strong, nonatomic) IBOutlet UITextField *addText;

@property (strong, nonatomic) IBOutlet UIImageView *addImage;

@property (strong, nonatomic) IBOutlet UIDatePicker *addDate;

@end
