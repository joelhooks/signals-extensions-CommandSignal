package org.robotlegs.test.support
{
	public class TestUintPropertyCommand
	{
		[Inject]
		public var uintProp:uint;
		
		[Inject]
		public var prop:TestCommandProperty;
		
		public function execute():void
		{
			prop.wasExecuted = uintProp is uint;
		}			
	}
}