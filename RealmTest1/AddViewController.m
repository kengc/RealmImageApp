//
//  AddViewController.m
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "AddViewController.h"
#import "AddModel.h"

@interface AddViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePicker; // 1

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imagePicker = [[UIImagePickerController alloc] init]; // 1
    
    self.imagePicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doneAction:(UIButton *)sender {
    
    AddModel *modelObject = [[AddModel alloc] init];
    
    modelObject.addText  = self.addText.text;
    
    //save image file to documents directory
    //save link as part of object

    //get directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //get count of items in directory
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *filelist= [filemgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    int count = [filelist count];
    
    //set path and file name and save image there
    NSString *imageName = [NSString  stringWithFormat:@"savedImage%d.png", count+1];
    NSString *savedImagePath = [documentsDirectory  stringByAppendingFormat:@"/savedImage%d.png", count+1];
    UIImage *image = self.addImage.image; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];

    modelObject.addImageName = imageName;
    modelObject.addImagePath = savedImagePath;
    
    modelObject.addDate  = self.addDate.date;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    
    // Add to Realm with transaction
    [realm beginWriteTransaction];
        [realm addObject:modelObject];
    [realm commitWriteTransaction];
    
    [self.delegate reloadTable];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addImageAction:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:nil]; // 3
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //self.pageImageView.image = selectedImage;
    //self.ImageViewImage = selectedImage;
    
    //self.pageModelObject.pageImage = selectedImage;
    
    self.addImage.image = selectedImage;
    
    //[self.delegate adjustPage:self.ob atIndex:self.index];
    
   // self.pageImageView.image = selectedImage;
    
    //[self.delegate savePageContent:self.pageModelObject];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
