package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IOpenRoomView extends IView {
		function get inputRoom():TextInput;
		function get goButton():Button;
	}
}
