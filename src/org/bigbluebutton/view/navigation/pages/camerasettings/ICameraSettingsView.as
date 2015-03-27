package org.bigbluebutton.view.navigation.pages.camerasettings
{
	import org.bigbluebutton.core.view.IView;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.RadioButtonGroup;

	public interface ICameraSettingsView extends IView
	{
		function get cameraProfilesList():List;
		function get startCameraButton():Button;
		function get swapCameraButton():Button;
	}
}