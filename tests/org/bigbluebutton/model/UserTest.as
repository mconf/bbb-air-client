package org.bigbluebutton.model {
	
	import org.flexunit.assertThat;
	
	public class UserTest {
		var user:User;
		
		[Before]
		public function setUp():void {
			var user:User = new User();
		}
		
		[Test]
		public function getAndSetUserID():void {
			user.userID = "1234"
			assertThat(user.userID, "1234");
		}
		
		[Test]
		public function getAndSetName():void {
			user.name = "qwerty"
			assertThat(user.name, "qwerty");
		}
	}
}
