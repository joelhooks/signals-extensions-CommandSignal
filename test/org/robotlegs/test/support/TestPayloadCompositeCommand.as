package org.robotlegs.test.support
{
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.mvcs.CompositeSignalCommand;

	public class TestPayloadCompositeCommand extends CompositeSignalCommand
	{
		public var property:TestCommandProperty;

		public function TestPayloadCompositeCommand()
		{
			property = new TestCommandProperty();
		}

		override protected function instantiateCommand(commandClass:Class, payloadClassList:Array = null, payloadValueList:Array = null):ISignalCommand
		{
			switch (commandClass)
			{
				case TestPayloadCommand:
					return super.instantiateCommand(commandClass, [TestCommandProperty], [property]);
			}

			return null;
		}
	}
}