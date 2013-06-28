//
//  PostsViewController.m
//  frontpage
//
//  Created by Gabriel O'Flaherty-Chan on 2013-06-28.
//  Copyright (c) 2013 Gabrieloc. All rights reserved.
//

#import "PostsViewController.h"
#import "Post.h"

@interface PostsViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation PostsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Posts";
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
//    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) NSLog(@"%@", error);
    NSLog(@"fetched: %@", self.fetchedResultsController);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refetchData)];
}

- (void)refetchData {
    self.fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = post.title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    cell.detailTextLabel.text = post.subreddit;
//    NSLog(@"cell.text: %@", cell.textLabel.text);
    if (post.thumbnail) {
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.thumbnail]]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGSize height = [post.title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, 172)];
    
    NSLog(@"got label height %f", height.height+50);
    return height.height+50;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"did change content to %i objects", controller.fetchedObjects.count);
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
