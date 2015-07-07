package org.bigbluebutton.view.navigation.pages.whiteboard
{
	import mx.core.IVisualElement;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IWhiteboardCanvas extends IView
	{
		function set resizeCallback(callback:Function):void;
		function get resizeCallback():Function;
		function get width():Number;
		function get height():Number;
		function addElement(element:IVisualElement):IVisualElement;
		function removeElement(element:IVisualElement):IVisualElement;
		function removeAllElements():void;
		function containsElement(element:IVisualElement):Boolean;
	}
}