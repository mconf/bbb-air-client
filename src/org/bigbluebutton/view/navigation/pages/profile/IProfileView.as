package org.bigbluebutton.view.navigation.pages.profile {
	
	import org.bigbluebutton.core.view.IView;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	public interface IProfileView extends IView {
		function get userNameButton():Button;
		function get userStatusButton():Button;
		function get clearStatusButton():Button;
		function get shareCameraButton():Button;
		function get shareCameraBtnLabel():String;
		function get shareMicButton():Button;
		function get shareMicBtnLabel():String;
		function get statusButton():Button;
		function get logoutButton():Button;
		function get currentState():String;
		function set currentState(value:String):void;
		function get handButton():Button;
	}
}
