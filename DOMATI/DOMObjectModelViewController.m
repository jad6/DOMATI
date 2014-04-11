//
//  DOMObjectModelViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 10/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMObjectModelViewController.h"

#import "DOMGroupSelectionViewController.h"
#import "DOMInfoViewController.h"

#import "DOMCalibrationPresenter.h"

#import "DOMStrengthGestureRecognizer.h"

// This data type is used to store information for each vertex
typedef struct {
    GLKVector3 positionCoords;
}
SceneVertex;

// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    { { -0.5f, -0.5f,  0.0      } }, // lower left corner
    { { 0.5f,  -0.5f,  0.0      } }, // lower right corner
    { { -0.5f, 0.5f,   0.0      } } // upper left corner
};

@interface DOMObjectModelViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic) GLuint vertexBufferID;

@end

@implementation DOMObjectModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    DOMStrengthGestureRecognizer *strengthGR = [[DOMStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(saveTouch:)];
    strengthGR.delegate = self;
    [self.view addGestureRecognizer:strengthGR];

    [self prepareObject];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (FIRST_LAUNCH)
    {
        [DOMCalibrationPresenter showCalibrationFromController:self
                                                    completion:nil];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"DOMAlreadyLaunched"];
        [defaults synchronize];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self clearObject];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Touch Strnegth Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)saveTouch:(DOMStrengthGestureRecognizer *)strengthGR
{
    NSLog(@"saveTouch");
}

#pragma mark - Open GL

- (void)prepareObject
{
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *glView = (GLKView *)self.view;

    NSAssert([glView isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");

    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    // Make the new context current
    [EAGLContext setCurrentContext:glView.context];

    // Create a base effect that provides standard OpenGL ES 2.0
    // Shading Language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
            1.0f,                                        // Red
            1.0f,                                        // Green
            1.0f,                                        // Blue
            1.0f);                                       // Alpha

    // Set the background color stored in the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color

    // Generate, bind, and initialize contents of a buffer to be
    // stored in GPU memory
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER,  // Initialize buffer contents
                 sizeof(vertices), // Number of bytes to copy
                 vertices,         // Address of bytes to copy
                 GL_STATIC_DRAW);  // Hint: cache in GPU memory
}

// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    // Clear Frame Buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT);

    // Enable use of positions from bound vertex buffer
    glEnableVertexAttribArray(GLKVertexAttribPosition);

    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,                   // three components per vertex
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex), // no gaps in data
                          NULL);               // NULL tells GPU to start at

    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)clearObject
{
    // Make the view's context current
    GLKView *glView = (GLKView *)self.view;

    [EAGLContext setCurrentContext:glView.context];

    // Delete buffers that aren't needed when view is unloaded
    if (0 != _vertexBufferID)
    {
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }

    // Stop using the context created in -viewDidLoad
    glView.context = nil;
    [EAGLContext setCurrentContext:nil];
}

#pragma mark - Logic

- (UIImage *)objectSnapshot
{
    GLKView *glView = (GLKView *)self.view;

    return [glView snapshot];
}

#pragma mark - Actions

- (IBAction)reset:(id)sender
{
    UIAlertView *resetAV = [[UIAlertView alloc] initWithTitle:@"Reset Model"
                                                      message:@"Would you like to reset the model to its initial shape?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];

    [resetAV show];
}

#pragma mark - Orientation

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notification
{

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

@end
