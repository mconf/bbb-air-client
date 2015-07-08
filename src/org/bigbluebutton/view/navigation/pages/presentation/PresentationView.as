package org.bigbluebutton.view.navigation.pages.presentation {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageOrientation;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageOrientationEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import mx.controls.SWFLoader;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import spark.components.Group;
	import spark.components.Image;
	import spark.primitives.Rect;
	
	public class PresentationView extends PresentationViewBase implements IPresentationView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function onClick(e:MouseEvent):void {
			//buttonTestSignal.dispatch();
		}
		
		public function get content():Group {
			return content0;
		}
		
		public function get viewport():Group {
			return viewport0;
		}
		
		public function get slide():SWFLoader {
			return slide0;
		}
		
		public function get whiteboardCanvas():WhiteboardCanvas {
			return whiteboardCanvas0;
		}
		
		public function setPresentationName(name:String):void {
			FlexGlobals.topLevelApplication.pageName.text = name;
		}
		
		public function setSlide(s:Slide):void {
			if (s != null) {
				var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				context.allowCodeImport = true;
				slide.loaderContext = context;
				slide.source = s.SWFFile.source;
			} else {
				slide.source = null;
			}
		}
		
		public function securityError(e:Event):void {
			trace("PresentationView.as Security error : " + e.toString());
		}
		
		override public function rotationHandler(rotation:String):void {
			switch (rotation) {
				case StageOrientation.ROTATED_LEFT:
					viewport.rotation = -90;
					viewport.scaleX = viewport.scaleY = slide.height / slide.width;
					break;
				case StageOrientation.ROTATED_RIGHT:
					viewport.rotation = 90;
					viewport.scaleX = viewport.scaleY = slide.height / slide.width;
					break;
				case StageOrientation.UPSIDE_DOWN:
					viewport.rotation = 180;
					viewport.scaleX = viewport.scaleY = 1;
					break;
				case StageOrientation.DEFAULT:
				case StageOrientation.UNKNOWN:
				default:
					viewport.rotation = 0;
					viewport.scaleX = viewport.scaleY = 1;
			}
		}
		
		public function dispose():void {
		}
	}
}
