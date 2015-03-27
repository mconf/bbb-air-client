package org.bigbluebutton.view.navigation.pages.camerasettings
{
	import spark.components.Button;
	import spark.components.List;
	import spark.components.RadioButtonGroup;

	public class CameraSettingsView extends CameraSettingsViewBase implements ICameraSettingsView
	{
		override protected function childrenCreated():void
		{
			super.childrenCreated();
		}
		
		public function dispose():void
		{
			
		}
		
		public function get startCameraButton():Button
		{
			return startCameraButton0;
		}		
		
		public function get cameraProfilesList():List
		{
			return cameraprofileslist;
		}
		
		public function get swapCameraButton():Button
		{
			return swapCameraBtn0;
		}
		
	}
}