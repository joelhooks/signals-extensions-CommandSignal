package org.robotlegs.test.support
{
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.mvcs.CompositeSignalCommand;

	public class TestValuePayloadCompositeCommand extends CompositeSignalCommand
	{
		public var property:TestCommandProperty;
		
		public function TestValuePayloadCompositeCommand()
		{
			property = new TestCommandProperty();
		}

		override protected function instantiateCommand(commandClass:Class, payload:Object = null, payloadClass:Class = null, payloadNamed:String = ""):ISignalCommand
		{
			switch (commandClass)
			{
				case TestValuePayloadCommand:
					return super.instantiateCommand(commandClass, property);
			}
			
			return null;
		}
	}
}