package org.robotlegs.test.support
{
	import org.robotlegs.mvcs.SignalCommand;
	
	public class TestValueClassNamedPayloadCommand extends SignalCommand
	{
		[Inject]
		public var signalBus:SignalBusTestClass;
		
		[Inject(name="TestCommandProperty")]
		public var property:TestCommandProperty;
		
		public function TestValueClassNamedPayloadCommand()
		{
		}
		
		override public function execute():void
		{
			signalBus.commandCompleted.dispatch(this);
		}
	}
}