SkeletonAnimationLibrary
======================
http://dragonbones.github.com/  

----------------------
Changelog (forked by KrechaGames): <br>
dragonBones / factorys / StarlingFactory.as <br>
dragonBones / objects / XMLDataParser.as

Now StarlingFactory can use TextureAtlas objects created by Starling and support contentScaleFactor.

Usage:

factory = new StarlingFactory ();<br>
factory.addEventListener(flash.events.Event.COMPLETE, bonesCompleteHandler);<br>
factory.skeletonData = XMLDataParser.parseSkeletonData ( skeletonData );<br>
factory.textureAtlasData = XMLDataParser.parseStarlingTextureAtlasData ( textureData, textureAtlas );

//skeletonData - xml skeleton data created by SkeletonAnimationDesignPanel;<br>
//textureData - xml texture data created by SkeletonAnimationDesignPanel - (unfortunately) we need it only to create TextureAtalsData with the pivot points;<br>
//textureAtlas - Starling.TextureAtlas;<br>

We can also use it like in this sample (but with contentScaleFactor support - only 1 or 2 values, otherwise generateArmature() must be edit in place where textures are create):<br>
[Example_Cyborg_XMLAndPNG.as](https://github.com/DragonBones/SkeletonAnimationDemos/blob/master/SkeletonAnimationLibraryDemos/src/Example_Cyborg_XMLAndPNG.as)

----------------------
Copyright 2012 the DragonBones Team

