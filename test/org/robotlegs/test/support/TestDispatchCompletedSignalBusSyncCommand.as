package org.robotlegs.test.support
{
	import org.robotlegs.mvcs.SignalCommand;
	
	public class TestDispatchCompletedSignalBusSyncCommand extends SignalCommand
	{
		[Inject]
		public var signalBus:SignalBusTestClass;
		
		public var hasExecuted:Boolean;
		
		public function TestDispatchCompletedSignalBusSyncCommand()
		{
		}
		
		override public function execute():void
		{
			hasExecuted = true;
			
			signalBus.commandCompleted.dispatch(this);
		}
	}
}