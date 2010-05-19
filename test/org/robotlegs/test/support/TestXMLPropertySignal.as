package org.robotlegs.test.support
{
    import org.osflash.signals.Signal;

    public class TestXMLPropertySignal extends Signal
    {
        public function TestXMLPropertySignal()
        {
            super(XML, TestCommandProperty);
        }
    }
}