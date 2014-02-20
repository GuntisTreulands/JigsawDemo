JigsawDemo
==========

![PreviewImage](https://github.com/GuntisTreulands/JigsawDemo/blob/master/example.gif?raw=true)

Simple Jigsaw example [CAShapeLayer]

————

This was just a “weekend project” (two weekends actually) over a year ago (early 2013).

Someone on StackOverflow (cannot find that question now :( ) asked how to create puzzle peaces from input image. At the beginning I suggested him to create masked puzzle peace images (each peace would mask all the image but the peace,  but this clearly is not the right way. So I started to tinker around to create a little demo. 

This example contains:
 - provide column/row count and it will generate necessary puzzle peaces with right width
 - each time generate randomly sides
 - can randomly position / rotate peaces at the beginning of launch
 - each peace can be rotated by tap, or by two fingers (like a real peace) - but once released, it will snap to 90/180/270/360 degrees
 - (!!*!!) each peace can be moved if touched on its “square” boundary and its outlined form 

Drawbacks:
 - no checking if peace is in its right place
 - if more than 100 peaces - it starts to lag, because, when picking up a peace, it goes through all subviews until it finds correct peace.



P.S.

 - (!!*!!) Will elaborate later
