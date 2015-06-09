package org.bigbluebutton.model {
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	
	public class UserListTest {
		
		[Test]
		public function addAndRemoveUser():void {
			var userList:UserList = new UserList();
			var user:User = new User();
			user.userID = "123";
			//user need a name. exception is raised otherwise
			user.name = "peter"
			userList.addUser(user);
			assertTrue(userList.hasUser("123"));
			userList.removeUser("123");
			assertFalse(userList.hasUser("123"));
		}
		
		[Test]
		public function getUser():void {
			var userList:UserList = new UserList();
			var user:User = new User();
			user.userID = "parker";
			userList.addUser(user);
			assertEquals(userList.getUser("parker"), userList.getUserByUserId("parker"));
		}
	}
}
