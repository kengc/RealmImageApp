//
//  AddModel.h
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>


@interface AddModel : RLMObject

@property (nonatomic) NSString *addText;
@property (nonatomic) NSString *addImageName;
@property (nonatomic) NSString *addImagePath;
@property (nonatomic) NSDate   *addDate;

@end
