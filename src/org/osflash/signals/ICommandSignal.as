package org.osflash.signals
{
    public interface ICommandSignal extends ISignal
    {
        function mapCommand(commandClass:Class, oneShot:Boolean=false):void;

        function hasMappedCommand(commandClass:Class):Boolean;

        function removeMappedCommand(commandClass:Class):void;
    }
}