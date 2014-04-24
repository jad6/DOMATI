//  DOMCircleView.m
// 
//  Created by Jad on 24/04/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
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

#import "DOMCircleView.h"

#import "DOMStrengthGestureRecognizer.h"

@interface DOMCircleView ()

@property (nonatomic) DOMCircleViewType type;

@end

@implementation DOMCircleView

- (instancetype)initWithFrame:(CGRect)frame
                      andType:(DOMCircleViewType)type
                     delegate:(id<DOMCircleViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.layer setCornerRadius:frame.size.width / 2.0];
        self.layer.masksToBounds = YES;
        
        self.type = type;
        self.delegate = delegate;
        
        NSError *error = nil;
        DOMStrengthGestureRecognizer *strengthGR = [[DOMStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered:) error:&error];
        
        if (error)
            [error handle];
        else
            [self addGestureRecognizer:strengthGR];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                       andType:DOMCircleViewTypeNormal
                      delegate:nil];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero
                       andType:DOMCircleViewTypeNormal
                      delegate:nil];
}

#pragma mark - Getters & Setters

- (void)setType:(DOMCircleViewType)type
{
    if (self->_type != type)
    {
        self->_type = type;
    }
    
    UIColor *color = nil;
    switch (self->_type)
    {
        case DOMCircleViewTypeSoft:
            color = [UIColor softCircleColor];
            break;
            
        case DOMCircleViewTypeNormal:
            color = [UIColor normalCircleColor];
            break;
            
        case DOMCircleViewTypeHard:
            color = [UIColor hardCircleColor];
            break;
    }
    
    self.backgroundColor = color;
}

#pragma mark - Action

- (void)tapRegistered:(DOMStrengthGestureRecognizer *)strengthGR
{
    CGFloat strength = strengthGR.strength;
    
    BOOL validTouch = NO;
    
    if (strength <= 0.33)
    {
        validTouch = (self.type == DOMCircleViewTypeSoft);
    }
    else if (strength > 0.33 && strength <= 0.66)
    {
        validTouch = (self.type == DOMCircleViewTypeNormal);
    }
    else if (strength > 0.66)
    {
        validTouch = (self.type == DOMCircleViewTypeHard);
    }
    
    if ([self.delegate respondsToSelector:@selector(circleView:didGetTapped:)])
    {
        [self.delegate circleView:self didGetTapped:validTouch];
    }
}

@end
