package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.VideoProfile;
	import org.osflash.signals.Signal;
	
	public class CameraQualitySignal extends Signal {
		public function CameraQualitySignal() {
			super(VideoProfile);
		}
	}
}
