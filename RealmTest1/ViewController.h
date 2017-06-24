//
//  ViewController.h
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "AddViewController.h"
#import "EditTableViewController.h"

@interface ViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, AddViewControllerProtocol, EditTableViewControllerProtocol>


@end

