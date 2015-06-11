package org.bigbluebutton.view.navigation.pages.camerasettings {
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.view.navigation.pages.camerasettings.cameraprofiles.CameraProfilesList;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.Scroller;
	import spark.components.VideoDisplay;
	
	public interface ICameraSettingsView extends IView {
		function get cameraProfilesList():List;
		function get startCameraButton():Button;
		function get swapCameraButton():Button;
		function get rotateCameraButton():Button;
		function get previewVideo():VideoDisplay;
		function get noVideoMessage():Label;
		function get videoGroup():Group;
		function get settingsGroup():Group;
		function get cameraSettingsScroller():Scroller;
		function get currentState():String
		function set currentState(value:String):void
	}
}
