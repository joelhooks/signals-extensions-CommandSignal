package org.robotlegs.test.support
{
    import mx.collections.ArrayCollection;

    public class TestArrayCollectionPropertyCommand
    {
        [Inject]
        public var testCollection:ArrayCollection;

        [Inject]
        public var prop:TestCommandProperty;

        public function execute():void
        {
            prop.wasExecuted = testCollection is ArrayCollection;
        }

    }
}