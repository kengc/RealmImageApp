//
//  EditTableViewController.m
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-24.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "EditTableViewController.h"

@interface EditTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePicker; // 1

@end

@implementation EditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.imagePicker = [[UIImagePickerController alloc] init]; // 1
    
    self.imagePicker.delegate = self;
    
    UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    
    [self.view addGestureRecognizer:TapGesture];
    
     [self setViewElements];
}

-(void)viewTap:(UITapGestureRecognizer *)sender{
    
    [self addImageAction];
    //UIColor *color = [sender.view.backgroundColor isEqual: [UIColor purpleColor]] ? [UIColor orangeColor] : [UIColor purpleColor];
    
    
    //sender.view.backgroundColor = color;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailItem:(AddModel *)model{
    if(model != nil){
        _modelObject = model;
    }
    
    [self setViewElements];
}
-(void)setRealmItem:(RLMRealm *)realmobject{
    if(realmobject != nil){
        _realmObject = realmobject;
    }
}


-(void)setViewElements{
    if (self.modelObject) {
        
        //self.detailTitle.text = [self.detailItem todoTitle];
        self.editTitleLabel.text = [self.modelObject addText];
        self.editDate.date = [self.modelObject addDate];
        self.filePathToDeleteImage = [self.modelObject addImagePath];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:self.modelObject.addImageName];
        NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];
        self.editImageView.image = [UIImage imageWithData:myData];
    }
}

#pragma mark - Table view data source

- (IBAction)doneAction:(UIButton *)sender {
    
    
    //delete old image associated with this object
    //NSString *appFile = [self.documentsDirectory stringByAppendingPathComponent:om.addImageName];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
   // NSString *filePath = [documentsPath stringByAppendingPathComponent:self.filePathToDeleteImage];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:self.filePathToDeleteImage error:&error];
    if (success) {
//        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//        [removedSuccessFullyAlert show];
        NSLog(@"File successfully delete at: %@", self.filePathToDeleteImage);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    
    //get count of items in directory
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *filelist= [filemgr contentsOfDirectoryAtPath:documentsPath error:nil];
    int count = [filelist count];
    
    //set path and file name and save image there
    NSString *imageName = [NSString  stringWithFormat:@"savedImage%d.png", count+1];
    NSString *savedImagePath = [documentsPath  stringByAppendingFormat:@"/savedImage%d.png", count+1];
    UIImage *image = self.editImageView.image; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    //modelObject.addImageName = imageName;
    //modelObject.addImagePath = savedImagePath;
    
    // Add to Realm with transaction
    [self.realmObject beginWriteTransaction];
    
    self.modelObject.addDate = self.editDate.date;
    self.modelObject.addText = self.editTitleLabel.text;
    self.modelObject.addImagePath = savedImagePath;
    self.modelObject.addImageName = imageName;
    
    //[self.realmObject addObject:modelObject];
    
    [self.realmObject commitWriteTransaction];

    
    [self.delegate reloadTable];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addImageAction{
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
    
    self.editImageView.image = selectedImage;
    
    //[self.delegate adjustPage:self.ob atIndex:self.index];
    
    // self.pageImageView.image = selectedImage;
    
    //[self.delegate savePageContent:self.pageModelObject];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
