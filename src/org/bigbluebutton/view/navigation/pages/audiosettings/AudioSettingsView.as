package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import spark.components.Button;
	import spark.components.ToggleSwitch;
	
	public class AudioSettingsView extends AudioSettingsViewBase implements IAudioSettingsView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get enableMic():ToggleSwitch {
			return enableMic0;
		}
		
		public function get enableAudio():ToggleSwitch {
			return enableAudio0;
		}
		
		public function get applyBtn():Button {
			return apply;
		}
	}
}
