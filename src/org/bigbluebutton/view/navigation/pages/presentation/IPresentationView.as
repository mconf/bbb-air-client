package org.bigbluebutton.view.navigation.pages.presentation {
	
	import mx.controls.SWFLoader;
	
	import spark.components.Group;
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public interface IPresentationView extends IView {
		function get content():Group;
		function get viewport():Group;
		function get slide():SWFLoader;
		function setSlide(s:Slide):void;
		function setPresentationName(name:String):void;
		function rotationHandler(rotation:String):void;
		function get whiteboardCanvas():WhiteboardCanvas;
	}
}
