//
//  EditProfileViewController.m
//  Decider
//
//  Created by kchan23 on 7/25/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        self.user = [PFUser currentUser];
    }
    
    PFFileObject *image = [self.user objectForKey:@"profilePicture"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            self.profileView.image = [UIImage imageWithData:data];
        }
        
    }];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/5;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didTapDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    doneButton.tintColor = UIColor.orangeColor;
}


- (IBAction)didTapDone:(id)sender {
    if(![self.passwordField.text  isEqual: @""]) {
        if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
            [self passwordMatchValidation];
        }
        else {
            [self.user setObject:self.passwordField.text forKey:@"password"];
        }
    }
    if(![self.nameField.text  isEqual: @""]) {
        [self.user setObject:self.nameField.text forKey:@"name"];
    }
    PFFileObject *imageFile = [self.user objectForKey:@"tempImage"];
    if(imageFile != nil) {
        [self.user setObject:imageFile forKey:@"profilePicture"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
            }
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapChange:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.originalImage = originalImage;
    self.editedImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    self.profileView.image = self.editedImage;
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data: imageData];
    [imageFile saveInBackground];
    [self.user setObject:imageFile forKey:@"tempImage"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)passwordMatchValidation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Change Password"
                                                                   message:@"Password does not match."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *passwordAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    [alert addAction:passwordAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
