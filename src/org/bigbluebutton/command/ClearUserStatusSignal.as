package org.bigbluebutton.command {
	
	import org.osflash.signals.Signal;
	
	public class ClearUserStatusSignal extends Signal {
		public function ClearUserStatusSignal() {
			/**
			 * @1 userID
			 */
			super(String);
		}
	}
}
