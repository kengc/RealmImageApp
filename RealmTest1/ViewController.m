//
//  ViewController.m
//  RealmTest1
//
//  Created by Kevin Cleathero on 2017-06-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "ViewController.h"

#import "AddModel.h"
#import "CustomTableViewCell.h"


@interface ViewController ()

@property (nonatomic) RLMResults<AddModel *> *addObject;
@property (nonatomic) NSMutableArray *objects;
@property (nonatomic) NSArray *paths;
@property (nonatomic) NSString *documentsDirectory;
@property (nonatomic) RLMRealm *realm;
@property (nonatomic) NSIndexPath *objectIndexPath;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.tableView.allowsSelection = YES;
    
    self.addObject = [AddModel allObjects]; // retrieves all Dogs from the default Realm
    
    self.objects = [[NSMutableArray alloc]init];
  
    self.realm = [RLMRealm defaultRealm];
    
    [self populateObjectFromRealm];

}
-(void)populateObjectFromRealm{
    
    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [self.paths objectAtIndex:0];
    AddModel *modelObject = [[AddModel alloc] init];
    [self.objects removeAllObjects];
    
    for(AddModel *am in self.addObject){
        modelObject = am;
        NSString *appFile = [self.documentsDirectory stringByAppendingPathComponent:am.addImageName];
        
        [self.realm beginWriteTransaction];
        modelObject.addImagePath = appFile;
        [self.realm commitWriteTransaction];
        
        [self.objects addObject:modelObject];
        
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    AddModel *om = self.objects[indexPath.row];
    
    NSString *appFile = [self.documentsDirectory stringByAppendingPathComponent:om.addImageName];
    NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];
    
    
    cell.imageCell.image = [UIImage imageWithData:myData];
    cell.imageTitleCell.text = om.addText;
    cell.imageDateDell.text = [om.addDate descriptionWithLocale:[NSLocale currentLocale]];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showAdd"]) {
        AddViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showEditView"]) {
        //AddModel *modelObject = [[AddModel alloc] init];
        EditTableViewController *ec = [segue destinationViewController];
        ec.delegate = self;
        AddModel *modelObject = [self.objects objectAtIndex:self.objectIndexPath.row];
        [ec setDetailItem:modelObject];
        [ec setRealmItem:self.realm];
    }

}
- (IBAction)addAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"showAdd" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.objectIndexPath = indexPath;
    [self performSegueWithIdentifier:@"showEditView" sender:self];
}

// Swipe to delete.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        

        AddModel *modelDelete = self.objects[indexPath.row];
        
        [self.realm beginWriteTransaction];
        [self.realm deleteObject:modelDelete];
        [self.realm commitWriteTransaction];
        
        
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self reloadTable];
        
    }
}

-(void)reloadTable{
    //[self.realm refresh];
    [self populateObjectFromRealm];
    [self.tableView reloadData];
}

@end
