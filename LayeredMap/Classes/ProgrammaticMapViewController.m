//
//  ProgrammaticMapViewController.m
//  ProgrammaticMap
//
//  Created by Hal Mueller on 3/25/09.
//  Copyright Route-Me Contributors 2009. All rights reserved.
//

#import "ProgrammaticMapViewController.h"
#import "RMMapView.h"
#import "RMDBMapSource.h"
#import "RMTileSource.h"
#import "RMOpenStreetMapSource.h"
#import "RMAnnotation.h"
#import "RMMarker.h"

@implementation ProgrammaticMapViewController

@synthesize mapView;

- (void)viewDidLoad
{
	NSLog(@"viewDidLoad");
    [super viewDidLoad];

	CLLocationCoordinate2D firstLocation;
	firstLocation.latitude = 51.2795;
	firstLocation.longitude = 1.082;

	CLLocationCoordinate2D coord;
    
    
    coord.latitude = 50.076866;
    coord.longitude = 14.417839;
    
    
    RMDBMapSource *  planSource = [[RMDBMapSource alloc]
                                   initWithPath:[[NSBundle mainBundle] pathForResource:@"mymap2.db" ofType:nil]] ;

    
    self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(10, 20, 300, 340)
                                             andTilesource:planSource
                                          centerCoordinate:coord
                                                 zoomLevel:21.0f
                                              maxZoomLevel:21.0f //[busTilesource maxZoom]//
                                              minZoomLevel:21.0f //[busTilesource minZoom] //
                                           backgroundImage:nil];
    
    
    self.mapView.delegate = self;
            //TestMapSource * googleSource = [[TestMapSource alloc] init];
    
    
    CLLocationCoordinate2D SW;
    CLLocationCoordinate2D NE;
    
    //X
    SW.longitude = [planSource topLeftOfCoverage].longitude;
    //Y
    SW.latitude = [planSource bottomRightOfCoverage].latitude;
    
    NE.latitude = [planSource topLeftOfCoverage].latitude;
    NE.longitude = [planSource bottomRightOfCoverage].longitude;
    
    
    [mapView setConstraintsSouthWest:SW northEast:NE];
    //[[self.mapView contents] setMinZoom:10.0];
	//[[self.mapView contents] setMaxZoom:21.0];
    //[[self.mapView contents] setZoom:21.0 ];
    
    UIImage *blueMarkerImage = [UIImage imageNamed:@"marker-blue.png"];

    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:mapView coordinate:coord andTitle:@"Test"];
    
    annotation.annotationIcon = blueMarkerImage;
    annotation.anchorPoint = CGPointMake(0.5, 1.0);
    
    [mapView addAnnotation:annotation];
    
    [mapView setBackgroundColor:[UIColor greenColor]];
	[[self view] addSubview:mapView];
	[[self view] sendSubviewToBack:mapView];
}
- (RMMapLayer *)mapView:(RMMapView *)aMapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer *marker = nil;
    
    
        marker = [[[RMMarker alloc] initWithUIImage:annotation.annotationIcon anchorPoint:annotation.anchorPoint] autorelease];
        
        if (annotation.title)
            [(RMMarker *)marker changeLabelUsingText:annotation.title];
        
        if ([annotation.userInfo objectForKey:@"foregroundColor"])
            [(RMMarker *)marker setTextForegroundColor:[annotation.userInfo objectForKey:@"foregroundColor"]];
        
        return marker;
}


- (void)dealloc
{
    [mapView removeFromSuperview];
	self.mapView = nil;
	[super dealloc];
}

- (IBAction)doTheTest:(id)sender
{
	CLLocationCoordinate2D secondLocation;
	secondLocation.latitude = 54.185;
	secondLocation.longitude = 12.09;
	[self.mapView setCenterCoordinate:secondLocation];
}

@end
