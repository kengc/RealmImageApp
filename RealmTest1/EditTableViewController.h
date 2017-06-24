//
//  EditTableViewController.h
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-24.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddModel.h"

@protocol EditTableViewControllerProtocol <NSObject>

-(void)reloadTable;

@end

@interface EditTableViewController : UIViewController

@property (weak, nonatomic) id<EditTableViewControllerProtocol> delegate;

@property (nonatomic) AddModel *modelObject;

@property (strong, nonatomic) IBOutlet UITextField *editTitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *editImageView;

@property (strong, nonatomic) IBOutlet UIDatePicker *editDate;

@property (nonatomic) NSString *filePathToDeleteImage;

@property (nonatomic) RLMRealm *realmObject;

-(void)setDetailItem:(AddModel *)model;
-(void)setRealmItem:(RLMRealm *)realmobject;

-(void)setViewElements;

@end
