JigsawDemo
==========

![PreviewImage](https://github.com/GuntisTreulands/JigsawDemo/blob/master/example.gif?raw=true)

Simple Jigsaw example using CAShapeLayer.

————

This was just a “weekend project” (two weekends actually) over a year ago (early 2013).

Someone on StackOverflow (cannot find that question now :( ) asked how to create puzzle pieces from input image. At the beginning I suggested him to create masked puzzle piece images (each piece would mask all the image but the piece,  but this clearly is not the right way. So I started to tinker around to create a little demo. 

This example contains:
 - provide column/row count and it will generate necessary puzzle pieces with correct width/height. The more columns/rows - the smaller the width/height and outline/inline puzzle form.
 - each time generate randomly sides
 - can randomly position / rotate pieces at the beginning of launch
 - each piece can be rotated by tap, or by two fingers (like a real piece) - but once released, it will snap to 90/180/270/360 degrees
 - each piece can be moved if touched on its “touchable shape” boundary (which is mostly the same visible puzzle shape, but WITHOUT inline shapes) 

Drawbacks:
 - no checking if piece is in its right place
 - if more than 100 pieces - it starts to lag, because, when picking up a piece, it goes through all subviews until it finds correct piece.


 BSD license
 ===

 	Copyright (c) 2013 Guntis Treulands.
 	All rights reserved.

 	Redistribution and use in source and binary forms are permitted
 	provided that the above copyright notice and this paragraph are
 	duplicated in all such forms and that any documentation,
 	advertising materials, and other materials related to such
 	distribution and use acknowledge that the software was developed
 	by Guntis Treulands.  The name of the
 	University may not be used to endorse or promote products derived
 	from this software without specific prior written permission.
 	THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 	IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
	