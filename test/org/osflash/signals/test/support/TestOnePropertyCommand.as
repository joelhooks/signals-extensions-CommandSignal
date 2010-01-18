package org.osflash.signals.test.support
{
    public class TestOnePropertyCommand
    {
        public var prop:TestCommandProperty;

        public function execute():void
        {
            prop.wasExecuted = true;
        }
    }
}