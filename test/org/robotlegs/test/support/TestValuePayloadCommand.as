package org.robotlegs.test.support
{
	import org.robotlegs.mvcs.SignalCommand;
	
	public class TestValuePayloadCommand extends SignalCommand
	{
		[Inject]
		public var signalBus:SignalBusTestClass;
		
		[Inject]
		public var property:TestCommandProperty;
		
		public function TestValuePayloadCommand()
		{
		}
		
		override public function execute():void
		{
			signalBus.commandCompleted.dispatch(this);
		}
	}
}