package org.bigbluebutton.core {
	
	public interface ISaveData {
		function save(name:String, obj:Object):void
		function read(name:String):Object
	}
}
