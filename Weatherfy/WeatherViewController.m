//
//  WeatherViewController.m
//  Weatherfy
//
//  Created by Eduardo Toledo on 12/13/17.
//  Copyright © 2017 SoSafe. All rights reserved.
//

#import "WeatherViewController.h"
#import "Weatherfy-Swift.h"


@import MapKit;

@interface WeatherViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *varianceLabel;
@end

@implementation WeatherViewController

- (void)viewDidLoad
{
 
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onActionButtonPressed:(UIButton *)sender
{
    [self.textField resignFirstResponder];
    [self updateLabels];
    [self getLocationFromAddressString:_textField.text];
    //[self moveMapToCoordinates:CLLocationCoordinate2DMake(0, 0)];
    DataSource *controller = [[DataSource alloc]init];
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[controller meanWithData:@"data" in: _textField.text]];
      NSNumber *myDoubleNumber2 = [NSNumber numberWithDouble:[controller varianceWithData:@"data" in: _textField.text]];
    _averageLabel.text = [myDoubleNumber stringValue];
    _varianceLabel.text = [myDoubleNumber2 stringValue];
    

    
}

- (void)updateLabels
{
    self.averageLabel.text = @"-1";
    self.varianceLabel.text = @"-1";

}

- (void)moveMapToCoordinates:(CLLocationCoordinate2D)coordinates
{
    [self.mapView setCenterCoordinate:coordinates animated:YES];
}
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    MKCoordinateSpan span =
    { .longitudeDelta = _mapView.region.span.longitudeDelta / 2,
        .latitudeDelta  = _mapView.region.span.latitudeDelta  / 2 };
    
    // Create a new MKMapRegion with the new span, using the center we want.
    MKCoordinateRegion region = { .center = center, .span = span };
    [_mapView setRegion:region animated:YES];
     //[self moveMapToCoordinates:CLLocationCoordinate2DMake(center.latitude, center.longitude)];
    return center;
    
}

@end
