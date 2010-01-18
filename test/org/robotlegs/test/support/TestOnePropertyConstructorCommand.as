package org.robotlegs.test.support
{
    public class TestOnePropertyConstructorCommand
    {
        public var prop:TestCommandProperty;
		
		public function TestOnePropertyConstructorCommand(prop:TestCommandProperty)
		{
			this.prop = prop;
		}

        public function execute():void
        {
            prop.wasExecuted = true;
        }
    }
}
