package org.bigbluebutton.model {
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	
	public class GuestListTests {
		
		[Test]
		public function addAndRemoveGuest():void {
			var guestList:GuestList = new GuestList();
			var guest:Guest = new Guest();
			guest.userID = "peter";
			guestList.addGuest(guest);
			assertTrue(guestList.hasGuest("peter"));
			guestList.removeGuest("peter");
			assertFalse(guestList.hasGuest("peter"));
		}
		
		[Test]
		public function getGuest():void {
			var guestList:GuestList = new GuestList();
			var guest:Guest = new Guest();
			guest.userID = "parker";
			guestList.addGuest(guest);
			assertEquals(guestList.getGuest("parker"), guestList.getGuestByGuestId("parker"));
		}
	}
}
