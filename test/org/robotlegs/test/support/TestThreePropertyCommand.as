package org.robotlegs.test.support
{
    public class TestThreePropertyCommand
    {
        [Inject]
        public var injectedProp:TestInjectedProperty;

        public var propOne:TestCommandProperty;

        public var propTwo:TestCommandProperty;

        public function execute():void
        {
            injectedProp.wasExecuted = propOne.wasExecuted = propTwo.wasExecuted = true;
        }
    }
}