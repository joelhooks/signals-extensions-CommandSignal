package org.robotlegs.core
{
    public interface ISignalContext extends IContext
    {
        function get signalCommandMap():ISignalCommandMap;
        function set signalCommandMap(value:ISignalCommandMap):void;
    }
}