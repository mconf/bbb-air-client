package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import org.bigbluebutton.core.view.IView;
	import spark.components.Button;
	import spark.components.ToggleSwitch;
	
	public interface IAudioSettingsView extends IView {
		function get enableMic():ToggleSwitch;
		function get enableAudio():ToggleSwitch;
		function get enablePushToTalk():ToggleSwitch;
		function get applyBtn():Button;
	}
}
