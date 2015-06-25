package org.bigbluebutton.view.navigation.pages.userdetails {
	
	import org.bigbluebutton.command.ChangeRoleCommand;
	import org.bigbluebutton.command.ChangeRoleSignal;
	import org.bigbluebutton.command.ClearUserStatusCommand;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.LockUserCommand;
	import org.bigbluebutton.command.LockUserSignal;
	import org.bigbluebutton.command.PresenterCommand;
	import org.bigbluebutton.command.PresenterSignal;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	public class UserDetaisConfig implements IConfig {
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var signalCommandMap:ISignalCommandMap;
		
		public function configure():void {
			dependencies();
			mediators();
			signals();
		}
		
		/**
		 * Specifies all the dependencies for the feature
		 * that will be injected onto objects used by the
		 * application.
		 */
		private function dependencies():void {
		}
		
		/**
		 * Maps view mediators to views.
		 */
		private function mediators():void {
			mediatorMap.map(IUserDetaisView).toMediator(UserDetaisViewMediator);
		}
		
		/**
		 * Maps signals to commands using the signalCommandMap.
		 */
		private function signals():void {
			signalCommandMap.map(ClearUserStatusSignal).toCommand(ClearUserStatusCommand);
			signalCommandMap.map(PresenterSignal).toCommand(PresenterCommand);
			signalCommandMap.map(ChangeRoleSignal).toCommand(ChangeRoleCommand);
			signalCommandMap.map(LockUserSignal).toCommand(LockUserCommand);
			//signalCommandMap.map(ButtonTestSignal).toCommand(ButtonTestCommand);
		}
	}
}
