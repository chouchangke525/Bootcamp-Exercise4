//
//  StableTableViewControler.m
//  TheStables
//
//  Created by T. Andrew Binkowski on 11/15/12.
//  Copyright (c) 2012 The University of Chicago, Department of Computer Science. All rights reserved.
//

#import "StableTableViewController.h"
#import "DetailViewController.h"
#import "Animal.h"

@interface StableTableViewController ()
@property (strong, nonatomic) NSMutableArray *reindeer;
@end

@implementation StableTableViewController

/*******************************************************************************
 * @method          fillTheStable
 * @abstract        Create animal objects and put them in an array
 * @description     
 ******************************************************************************/
- (void)fillTheStable
{
    // Raw data
    NSArray *reindeerNames = [NSArray arrayWithObjects:@"Dasher",@"Dancer",@"Prancer",@"Vixen", @"Comet",@"Cupid",@"Donner",@"Blitzen",@"Rudolph",nil];
    NSArray *reindeerURLs = @[
        @"http://farm3.staticflickr.com/2151/2133661509_c54ce96fe5_q.jpg", @"http://farm3.staticflickr.com/2393/2133661737_3feae4ca89_q.jpg",
        @"http://farm1.staticflickr.com/182/425617969_6cd61245b9_q.jpg", @"http://farm4.staticflickr.com/3042/2789917789_988c62c953_q.jpg",
        @"http://farm5.staticflickr.com/4138/4882986746_e738e13515_q.jpg", @"http://farm6.staticflickr.com/5246/5218832836_5cce08e1d2_q.jpg",
        @"http://farm3.staticflickr.com/2166/2158779446_5649063620_q.jpg", @"http://farm9.staticflickr.com/8044/8088504348_307589e545_q.jpg",
        @"http://farm1.staticflickr.com/18/24149922_1fc1167e86_q.jpg"];
    
    // Initialize the reindeer property
    _reindeer = [NSMutableArray array];
    
    // Create a new Animal object for each reindeer
    Animal *currentAnimal;
    for (int i=0; i<[reindeerNames count]; i++) {
        currentAnimal = [[Animal alloc] init];
        currentAnimal.type = @"Reindeer";
        currentAnimal.name = [reindeerNames objectAtIndex:i];
        currentAnimal.age = [NSNumber numberWithInt:100];
        currentAnimal.imageURL = [NSURL URLWithString:[reindeerURLs objectAtIndex:i]];

        // Add the object to the reindeer array
        [self.reindeer addObject:currentAnimal];
    }
    NSLog(@">>>> Reindeer:%@",self.reindeer);
}

/*******************************************************************************
 * @method          viewDidLoad
 * @abstract        Called when view loads
 * @description      
 ******************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fillTheStable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.reindeer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnimalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    // Get the current reindeer from the row index
    Animal *currentAnimal = [self.reindeer objectAtIndex:indexPath.row];
    cell.textLabel.text = currentAnimal.name;
    cell.detailTextLabel.text = currentAnimal.type;    
    [self setImageForCell:cell fromUrl:currentAnimal.imageURL];
    
    NSLog(@">>>> Asking for cell:%d for data:%@", indexPath.row,self.reindeer[indexPath.row]);
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
   
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>> Clicked on cell %d", indexPath.row);
}

# pragma mark - Segue
/*******************************************************************************
 * @method          prepareForSegue:sender
 * @abstract        Call before the segue
 * @description     Pass the animal data
 ******************************************************************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Animal *selectedReindeer = [self.reindeer objectAtIndex:path.row];
    [segue.destinationViewController setCurrentAnimal:selectedReindeer];
}

/*******************************************************************************
 * @method          setImageForCell:fromUrl
 * @abstract        Async donwload of image data from a passed URL; the image is assigned to the cell that is passed
 * @description     WARNING: This is not a safe implementation of async downloading, check out AFNetworking on github for good example
 ******************************************************************************/
- (void) setImageForCell:(UITableViewCell*)theCell fromUrl:(NSURL*)theUrl
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // Define an image
        UIImage *downloadImage = nil;

        // Download data from the URL address
        NSData *responseData = [NSData dataWithContentsOfURL:theUrl];
        
        // Convert data to UIImage
        downloadImage = [UIImage imageWithData:responseData];

        // Check if image exists (download was ok)
        if (downloadImage) {

            // UI can't be updated from background thread, get back on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Assign the image to the cell properties
                theCell.imageView.image = downloadImage;

                // Redraw the cell
                [theCell setNeedsLayout];
            });
        } else {
            NSLog(@"-- impossible download: %@", theUrl);
        }
	});
}
@end
