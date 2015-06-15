package org.bigbluebutton.model {
	
	import org.flexunit.assertThat;
	
	public class UserTest {
		
		[Test]
		public function getAndSetUserID():void {
			var user:User = new User();
			user.userID = "1234"
			assertThat(user.userID, "1234");
		}
		
		[Test]
		public function getAndSetName():void {
			var user:User = new User();
			user.name = "qwerty"
			assertThat(user.name, "qwerty");
		}
	}
}
