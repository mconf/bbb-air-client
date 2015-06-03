package org.bigbluebutton.model {
	
	import org.flexunit.assertThat;
	
	public class GuestTests {
		
		[Test]
		public function getAndSetUserID():void {
			var guest:Guest = new Guest();
			guest.userID = "1234"
			assertThat(guest.userID, "1234");
		}
		
		[Test]
		public function getAndSetName():void {
			var guest:Guest = new Guest();
			guest.name = "qwerty"
			assertThat(guest.name, "qwerty");
		}
	}
}
