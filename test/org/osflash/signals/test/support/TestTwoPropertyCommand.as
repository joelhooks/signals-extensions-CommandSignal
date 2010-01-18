package org.osflash.signals.test.support
{
    public class TestTwoPropertyCommand
    {
        public var propOne:TestCommandProperty;
        public var propTwo:TestCommandProperty;

        public function execute():void
        {
            propOne.wasExecuted = propTwo.wasExecuted = true;
        }
    }
}