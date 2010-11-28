package org.robotlegs.test.support
{
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.mvcs.CompositeSignalCommand;

	public class TestValueClassNamedPayloadCompositeCommand extends CompositeSignalCommand
	{
		public var property:TestCommandProperty;
		
		public function TestValueClassNamedPayloadCompositeCommand()
		{
			property = new TestCommandProperty();
		}

		override protected function instantiateCommand(commandClass:Class, payload:Object = null, payloadClass:Class = null, payloadNamed:String = ""):ISignalCommand
		{
			switch (commandClass)
			{
				case TestValueClassNamedPayloadCommand:
					return super.instantiateCommand(commandClass, property, TestCommandProperty, "TestCommandProperty");
			}
			
			return null;
		}
	}
}