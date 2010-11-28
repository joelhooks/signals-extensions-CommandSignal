package org.robotlegs.test.support
{
    public class TestXMLPropertyCommand
    {
        [Inject]
        public var xmlProp:XML;

        [Inject]
        public var prop:TestCommandProperty;

        public function execute():void
        {
            prop.wasExecuted = xmlProp is XML;
        }
    }
}