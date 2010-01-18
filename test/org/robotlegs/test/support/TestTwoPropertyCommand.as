package org.robotlegs.test.support
{
    public class TestTwoPropertyCommand
    {
		[Inject]
        public var propOne:TestCommandProperty;
		
		[Inject]
        public var propTwo:TestCommandProperty2;

        public function execute():void
        {
            propOne.wasExecuted = propTwo.wasExecuted = true;
        }
    }
}
