package org.bigbluebutton.view.navigation.pages.locksettings {
	
	import spark.components.Button;
	import spark.components.ToggleSwitch;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface ILockSettingsView extends IView {
		function get cameraSwitch():ToggleSwitch;
		function get micSwitch():ToggleSwitch;
		function get publicChatSwitch():ToggleSwitch;
		function get privateChatSwitch():ToggleSwitch;
		function get applyButton():Button;
		function get layoutSwitch():ToggleSwitch;
	}
}
