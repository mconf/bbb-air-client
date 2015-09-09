package org.bigbluebutton.view.navigation.pages.splitsettings {
	
	import flash.events.Event;
	
	public class SplitViewEvent extends Event {
		public static const CHANGE_VIEW:String = "changeView";
		
		public function SplitViewEvent(type:String, view:Class, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.view = view;
		}
		
		public var view:Class;
		
		override public function clone():Event {
			return new SplitViewEvent(type, view, bubbles, cancelable);
		}
	}
}
