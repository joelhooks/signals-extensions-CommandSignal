package org.robotlegs.test.support
{
	public class TestIntPropertyCommand
	{
		[Inject]
		public var intProp:int;
		
		[Inject]
		public var prop:TestCommandProperty;
		
		public function execute():void
		{
			prop.wasExecuted = intProp is int;
		}			
	}
}