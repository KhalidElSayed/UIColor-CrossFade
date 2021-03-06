/**
 * Copyright (c) 2012 Charles Powell
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

//  CPViewController.m
//  UIColorCrossFadeDemo

#import "CPViewController.h"

#import "UIColor+CrossFade.h"

#import "InfColorPicker.h"
#import "CPButtonView.h"
#import <QuartzCore/QuartzCore.h>

@interface CPViewController ()

@property (nonatomic, weak) CPButtonView *changedColor;

@end

@implementation CPViewController

@synthesize slider, label;
@synthesize colorA, colorB, buttonA, buttonB;
@synthesize linearStep1, linearStep2, linearStep3, linearStep4, linearStep5;
@synthesize powfStep1, powfStep2, powfStep3, powfStep4, powfStep5;
@synthesize changedColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
    self.colorA = [UIColor redColor];
    self.colorB = [UIColor blueColor];
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSArray *stepColorsLinear = [UIColor colorsForFadeBetweenFirstColor:[UIColor redColor] 
                                                        lastColor:[UIColor blueColor] 
                                                withRatioEquation:^(float input) {
                                                    return input;
                                                }
                                                          inSteps:5];
    
    self.linearStep1.backgroundColor = [stepColorsLinear objectAtIndex:0];
    self.linearStep2.backgroundColor = [stepColorsLinear objectAtIndex:1];
    self.linearStep3.backgroundColor = [stepColorsLinear objectAtIndex:2];
    self.linearStep4.backgroundColor = [stepColorsLinear objectAtIndex:3];
    self.linearStep5.backgroundColor = [stepColorsLinear objectAtIndex:4];
    
    NSArray *stepColorsPowf = [UIColor colorsForFadeBetweenFirstColor:[UIColor redColor] 
                                                              lastColor:[UIColor blueColor] 
                                                      withRatioEquation:^(float input) {
                                                          return powf(input, 1/4.0f);
                                                      }
                                                                inSteps:5];
    
    self.powfStep1.backgroundColor = [stepColorsPowf objectAtIndex:0];
    self.powfStep2.backgroundColor = [stepColorsPowf objectAtIndex:1];
    self.powfStep3.backgroundColor = [stepColorsPowf objectAtIndex:2];
    self.powfStep4.backgroundColor = [stepColorsPowf objectAtIndex:3];
    self.powfStep5.backgroundColor = [stepColorsPowf objectAtIndex:4];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)sliderValueChanged:(id)sender {
    self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
    
    UIColor *crossFade = [UIColor colorForFadeBetweenFirstColor:self.colorA secondColor:self.colorB atRatio:self.slider.value];
    self.view.backgroundColor = crossFade;
}

- (void)colorViewTapped:(id)sender {

    InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
    
    CPButtonView *colorButton = sender;
    self.changedColor = colorButton;
    picker.sourceColor = colorButton.backgroundColor;
    picker.delegate = self;
    [picker presentModallyOverViewController:self];
	
}

- (void)colorPickerControllerDidFinish:(InfColorPickerController*)picker {
    if (self.changedColor == self.buttonA) {
        self.colorA = picker.resultColor;
        self.buttonA.backgroundColor = colorA;
    } else if (self.changedColor == self.buttonB) {
        self.colorB = picker.resultColor;
        self.buttonB.backgroundColor = colorB;
    } else {
        NSLog(@"wat");
    }
    
    UIColor *crossFade = [UIColor colorForFadeBetweenFirstColor:self.colorA secondColor:self.colorB atRatio:self.slider.value];
    
    NSArray *stepColorsLinear = [UIColor colorsForFadeBetweenFirstColor:self.colorA
                                                        lastColor:self.colorB
                                                withRatioEquation:^(float input) {
                                                    return input;
                                                }
                                                          inSteps:5];
    
    NSArray *stepColorsPowf = [UIColor colorsForFadeBetweenFirstColor:self.colorA
                                                            lastColor:self.colorB
                                                    withRatioEquation:^(float input) {
                                                        return powf(input, 1/4.0f);
                                                    }
                                                              inSteps:5];
    
    [UIView animateWithDuration:1.0
                          delay:0.4
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.backgroundColor = crossFade;
                         // Linear
                         self.linearStep1.backgroundColor = [stepColorsLinear objectAtIndex:0];
                         self.linearStep2.backgroundColor = [stepColorsLinear objectAtIndex:1];
                         self.linearStep3.backgroundColor = [stepColorsLinear objectAtIndex:2];
                         self.linearStep4.backgroundColor = [stepColorsLinear objectAtIndex:3];
                         self.linearStep5.backgroundColor = [stepColorsLinear objectAtIndex:4];
                         // Powf
                         self.powfStep1.backgroundColor = [stepColorsPowf objectAtIndex:0];
                         self.powfStep2.backgroundColor = [stepColorsPowf objectAtIndex:1];
                         self.powfStep3.backgroundColor = [stepColorsPowf objectAtIndex:2];
                         self.powfStep4.backgroundColor = [stepColorsPowf objectAtIndex:3];
                         self.powfStep5.backgroundColor = [stepColorsPowf objectAtIndex:4];
                     }
                     completion:^(BOOL finished) {
                         //Done
                         
                     }];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
