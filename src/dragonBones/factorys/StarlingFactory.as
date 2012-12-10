package dragonBones.factorys
{
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.display.StarlingDisplayBridge;
	import dragonBones.objects.Node;
	import dragonBones.objects.SubTextureData;
	import dragonBones.objects.TextureAtlasData;
	import dragonBones.utils.BytesType;
	import dragonBones.utils.ConstValues;
	import dragonBones.utils.dragonBones_internal;
	import flash.events.Event;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	use namespace dragonBones_internal;
	
	/**
	 * A object managing the set 	of armature resources for Starling engine. It parses the raw data, stores the armature resources and creates armature instrances.
	 * Forekd by KrechaGames - Łuaksz Cywiński - add support for Starling.TextureAtlas with contentScaleFactor
	 * @see dragonBones.Armature
	 */
	public class StarlingFactory extends BaseFactory
	{		
		/** @private */
		public static function getTextureDisplay(textureAtlasData:TextureAtlasData, fullName:String):Image
		{
			var subTextureData:SubTextureData = textureAtlasData.getSubTextureData (fullName);			
			var scaleFactor:Number = Starling.contentScaleFactor;
			if ( scaleFactor != 1 ){
				var tempSubTextureData:SubTextureData = new SubTextureData ();
				tempSubTextureData.x = subTextureData.x / scaleFactor;
				tempSubTextureData.y = subTextureData.y / scaleFactor;
				tempSubTextureData.width = subTextureData.width / scaleFactor;
				tempSubTextureData.height = subTextureData.height / scaleFactor;
				tempSubTextureData.pivotX = subTextureData.pivotX / scaleFactor;
				tempSubTextureData.pivotY = subTextureData.pivotY / scaleFactor;
				subTextureData = tempSubTextureData;
			}
			
			if (subTextureData)
			{
				var subTexture:SubTexture;
				if ( textureAtlasData._starlingTexture is TextureAtlas ) {
					subTexture = TextureAtlas (textureAtlasData._starlingTexture).getTexture (fullName) as SubTexture;			
				}else {
					subTexture = textureAtlasData.getStarlingSubTexture(fullName) as SubTexture;
					if(!subTexture)
					{
						subTexture = new SubTexture(textureAtlasData._starlingTexture as Texture, subTextureData);
						textureAtlasData.addStarlingSubTexture(fullName, subTexture);
					}
				}
					
				var image:Image = new Image(subTexture);
				image.pivotX = subTextureData.pivotX;
				image.pivotY = subTextureData.pivotY;
				
				return image;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set textureAtlasData(value:TextureAtlasData):void
		{
			super.textureAtlasData = value;			
			
			if ( textureAtlasData._starlingTexture ) {								
				textureAtlasData.dispatchEvent(new Event(Event.COMPLETE));
			}else if(_textureAtlasData)
			{
				_textureAtlasData.bitmap;
			}
		}
		/**
		 * Specifies whether this object disposes bitmap data.
		 */
		public var autoDisposeBitmapData:Boolean = true;
		
		/**
		 * Creates a new <code>StarlingFactory</code>
		 */
		public function StarlingFactory()
		{
			super();
		}	
		
		override protected function generateArmature():Armature
		{
			if (!textureAtlasData._starlingTexture)
			{
				if(textureAtlasData.dataType == BytesType.ATF)
				{
					textureAtlasData._starlingTexture = Texture.fromAtfData(textureAtlasData.rawData, Starling.contentScaleFactor);//cywil: , Starling.contentScaleFactor
				}
				else
				{
					textureAtlasData._starlingTexture = Texture.fromBitmap(textureAtlasData.bitmap, true, false, Starling.contentScaleFactor);//cywil: , true, false, Starling.contentScaleFactor
					//no need to keep the bitmapData
					if (autoDisposeBitmapData)
					{
						textureAtlasData.bitmap.bitmapData.dispose();
					}
				}
			}
			
			var armature:Armature = new Armature (new Sprite ());			
			return armature;
		}
		
		override protected function generateBone():Bone
		{
			var bone:Bone = new Bone(new StarlingDisplayBridge());
			return bone;
		}
		
		override protected function getBoneTextureDisplay(textureName:String):Object
		{
			return getTextureDisplay(_textureAtlasData, textureName);
		}
	}
}