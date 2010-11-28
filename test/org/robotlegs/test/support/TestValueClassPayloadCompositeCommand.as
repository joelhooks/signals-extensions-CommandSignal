package org.robotlegs.test.support
{
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.mvcs.CompositeSignalCommand;

	public class TestValueClassPayloadCompositeCommand extends CompositeSignalCommand
	{
		public var property:TestCommandProperty;

		public function TestValueClassPayloadCompositeCommand()
		{
			property = new TestCommandProperty();
		}

		override protected function instantiateCommand(commandClass:Class, payload:Object = null, payloadClass:Class = null, payloadNamed:String = ""):ISignalCommand
		{
			switch (commandClass)
			{
				case TestValueClassPayloadCommand:
					return super.instantiateCommand(commandClass, property, TestCommandProperty);
			}

			return null;
		}
	}
}