VideoToGif
==========

主要支持一些Mac本身可播放的小视频转换，原理是利用QTKit把视频转成一帧帧图片，然后再把图片用CGImageDestination保存成Gif格式。

为了支持OSX10.6平台才使用QTKit,10.7及以上的可以用AVFoudation来生成，效果会好一些。在10.6以下生成的Gif图片，Finder不支持查看，可以用Safari打开查看。
