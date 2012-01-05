//
//  main.m
//  MadChatter
//
//  Created by Andrew Havens on 1/4/12.
//  Copyright (c) 2012 Devout Design. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
