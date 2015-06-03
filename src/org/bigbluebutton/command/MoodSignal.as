package org.bigbluebutton.command {
	
	import org.osflash.signals.Signal;
	
	public class MoodSignal extends Signal {
		public function MoodSignal() {
			/**
			 * @1 mood
			 */
			super(String);
		}
	}
}
