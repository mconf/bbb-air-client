package org.bigbluebutton.model {
	
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.flexunit.asserts.assertEquals;
	
	public class UserUISessionTest {
		var userUISession:UserUISession;
		
		[Before]
		public function setUp():void {
			userUISession = new UserUISession();
		}
		
		[Test]
		public function pages():void {
			userUISession.pushPage(PagesENUM.CAMERASETTINGS);
			userUISession.pushPage(PagesENUM.AUDIOSETTINGS);
			userUISession.pushPage(PagesENUM.DESKSHARE);
			userUISession.pushPage(PagesENUM.EXIT);
			assertEquals(userUISession.currentPage, PagesENUM.EXIT);
			userUISession.popPage();
			assertEquals(userUISession.currentPage, PagesENUM.DESKSHARE);
			userUISession.popPage();
			assertEquals(userUISession.currentPage, PagesENUM.AUDIOSETTINGS);
			userUISession.popPage();
			assertEquals(userUISession.currentPage, PagesENUM.CAMERASETTINGS);
		}
	}
}
