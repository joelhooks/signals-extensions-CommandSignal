package org.robotlegs.test.support
{
    import mx.collections.ArrayCollection;

    import org.osflash.signals.Signal;

    public class TestArrayCollectionPropertySignal extends Signal
{
    public function TestArrayCollectionPropertySignal()
    {
        super(ArrayCollection, TestCommandProperty);
    }
}
}