package org.bigbluebutton {
	
	import org.bigbluebutton.model.GuestListTests;
	import org.bigbluebutton.model.GuestTests;
	import org.bigbluebutton.ui.MicButtonConfigTests;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AppTestSuite {
		public var guestTests:GuestTests;
		
		public var guestListTests:GuestListTests;
	}
}
