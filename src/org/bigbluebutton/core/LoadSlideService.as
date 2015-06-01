package org.bigbluebutton.core {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.ByteArray;
	import mx.controls.SWFLoader;
	import org.bigbluebutton.model.presentation.Slide;
	
	public class LoadSlideService {
		private var _loader:Loader = new Loader();
		
		private var _slide:Slide;
		
		public function LoadSlideService(s:Slide) {
			trace("LoadSlideService: loading a new slide");
			_slide = s;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderComplete);
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			//context.allowCodeImport = true;
			if (Security.sandboxType == Security.REMOTE) {
				context.securityDomain = SecurityDomain.currentDomain;
			}
			_loader.load(new URLRequest(_slide.slideURI), context);
		}
		
		private function handleLoaderComplete(e:Event):void {
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			_slide.SWFFile.loaderContext = context;
			_slide.swfSource = e.target.bytes;
			trace("LoadSlideService: loading of slide data finished successfully");
		}
	}
}
