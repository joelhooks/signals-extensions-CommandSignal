package org.robotlegs.test.support
{
    public class TestTwoPropertyConstructorCommand
    {
        public var propOne:TestCommandProperty;
        public var propTwo:TestCommandProperty2;
		
		public function TestTwoPropertyConstructorCommand(propOne:TestCommandProperty, propTwo:TestCommandProperty2)
		{
			this.propOne = propOne;
			this.propTwo = propTwo;
		}

        public function execute():void
        {
            propOne.wasExecuted = propTwo.wasExecuted = true;
        }
    }
}
