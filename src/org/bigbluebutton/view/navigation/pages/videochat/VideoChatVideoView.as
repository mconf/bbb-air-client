package org.bigbluebutton.view.navigation.pages.videochat {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.geom.*;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;
	import org.bigbluebutton.view.navigation.pages.common.VideoView;
	
	public class VideoChatVideoView extends VideoView {
		private var _userName:TextField;
		
		private var _shape:Shape;
		
		private var _loader:Loader;
		
		public function setVideoPosition(name:String):void {
			if (video && video.parent) {
				var videoParent:DisplayObjectContainer = video.parent;
				video.parent.removeChild(video);
				resizeForPortrait();
				var topActionBarHeight:Number = FlexGlobals.topLevelApplication.topActionBar.height;
				video.x = (videoParent.width - video.width) / 2;
				addLoadingImage();
				if (!videoParent.contains(_loader)) {
					videoParent.addChild(_loader);
				}
				videoParent.addChild(video);
			}
			identifyVideoStream(video.x, video.height + video.y, name);
		}
		
		public function get videoViewVideo() {
			return video;
		}
		
		private function identifyVideoStream(x:Number, y:Number, name:String):void {
			this.styleName = "videoTextFieldStyle";
			var nameFormat:TextFormat = new TextFormat();
			nameFormat.size = this.getStyle("fontSize");
			nameFormat.font = this.getStyle("fontFamily");
			nameFormat.indent = this.getStyle("indent");
			_userName = new TextField();
			_userName.autoSize = TextFieldAutoSize.LEFT;
			_userName.text = name;
			_userName.textColor = this.getStyle("color");
			_userName.setTextFormat(nameFormat, 0, name.length);
			_userName.x = x;
			_userName.y = y - _userName.textHeight * 1.5;
			var gradientMatrixWidth:Number = video.width;
			var gradientMatrixHeight:Number = _userName.height * 2;
			var gradientMatrixRotation:Number = 1.57;
			var gradientTx:Number = 0;
			var gradientTy:Number = 0;
			var gradientDrawWidth:Number = video.width;
			var gradientDrawHeight:Number = _userName.height * 2;
			var gradientOffsetX:Number = video.x;
			var gradientOffsetY:Number = video.y + video.height - gradientDrawHeight;
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(gradientMatrixWidth, gradientMatrixHeight, gradientMatrixRotation, gradientTx + gradientOffsetX, gradientTy + gradientOffsetY);
			var gradientType:String = GradientType.LINEAR;
			var gradientColors:Array = [0x606060, 0x393939, 0x1C1C1C, 0x000000];
			var gradientAlphas:Array = [0, 0.3, 0.6, 1];
			var gradientRatios:Array = [0, 90, 180, 255];
			var gradientSpreadMethod:String = SpreadMethod.PAD;
			var gradientInterpolationMethod:String = InterpolationMethod.LINEAR_RGB;
			var gradientFocalPoint:Number = 0;
			_shape = new Shape();
			var gradientGraphics:Graphics = _shape.graphics;
			gradientGraphics.beginGradientFill(gradientType, gradientColors, gradientAlphas, gradientRatios, gradientMatrix, gradientSpreadMethod, gradientInterpolationMethod, gradientFocalPoint);
			gradientGraphics.drawRect(gradientOffsetX, gradientOffsetY, gradientDrawWidth, gradientDrawHeight);
			gradientGraphics.endFill();
			video.parent.addChild(_shape);
			video.parent.addChild(_userName);
		}
		
		override public function close():void {
			if (video) {
				if (_userName && video.parent.contains(_userName)) {
					video.parent.removeChild(_userName);
				}
				if (_shape && video.parent.contains(_shape)) {
					video.parent.removeChild(_shape);
				}
				if (_loader && video.parent.contains(_loader)) {
					video.parent.removeChild(_loader);
				}
			}
			super.close();
		}
		
		private function addLoadingImage():void {
			this.styleName = "videoTextFieldStyle";
			var url:URLRequest = new URLRequest(this.getStyle("loadingImageSource"));
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			_loader.load(url);
		}
		
		private function onImageLoaded(e:Event):void {
			_loader.x = (screenWidth - _loader.content.width) / 2;
			if (video) {
				_loader.y = (video.height - _loader.height) / 2;
			}
			_loader.alpha = 0.5;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
		}
		
		public function onMetaData(... rest):void {
			trace("onMetaData() " + ObjectUtil.toString(rest));
		}
	}
}
