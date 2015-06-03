package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.User;
	import org.osflash.signals.Signal;
	
	public class PresenterSignal extends Signal {
		public function PresenterSignal() {
			/**
			 * @1 user, userMe.userID
			 */
			super(User, String);
		}
	}
}
