package org.bigbluebutton.view.navigation.pages.splitsettings {
	
	import spark.components.ViewNavigator;
	
	public class SplitSettingsView extends SplitSettingsViewBase implements ISplitSettingsView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get settingsNavigator():ViewNavigator {
			return settingsnavigator0;
		}
		
		public function get leftMenu():ViewNavigator {
			return leftmenu0;
		}
	}
}
