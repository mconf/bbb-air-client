package org.bigbluebutton.command
{
	import org.osflash.signals.Signal;
	
	import org.bigbluebutton.model.chat.ChatMessage;
	
	public class PublicChatMessageSignal extends Signal
	{
		public function PublicChatMessageSignal()
		{
			/**
			 * @1 
			 */
			super(ChatMessage);
		}
	}
}