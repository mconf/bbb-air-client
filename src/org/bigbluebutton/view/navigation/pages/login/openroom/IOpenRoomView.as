package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.view.ui.NavigationButton;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.TextInput;
	
	public interface IOpenRoomView extends IView {
		function get inputRoom():TextInput;
		function get goButton():Button;
	}
}
