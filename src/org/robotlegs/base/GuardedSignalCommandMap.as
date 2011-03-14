package org.robotlegs.base {
import flash.utils.Dictionary;
import flash.utils.describeType;

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
import org.robotlegs.core.IReflector;

public class GuardedSignalCommandMap extends SignalCommandMap implements IGuardedSignalCommandMap {

    protected var verifiedGuardClasses:Dictionary;

    public const E_GUARD_NOIMPL:String = 'Guard Class does not implement an approve() method';

    public function GuardedSignalCommandMap(injector:IInjector, reflector:IReflector) {
        super(injector);
        this.verifiedGuardClasses = new Dictionary(false);
    }

    //---------------------------------------
    // IGuardedCommandMap Implementation
    //---------------------------------------

    /**
     * @inheritDoc
    */
    public function mapGuardedSignal(signal:ISignal, commandClass:Class, guards:*, oneShot:Boolean = false):void {
        verifyCommandClass(commandClass);

        if (!(guards is Array)) {
            guards = [guards];
        }

        verifyCommandClass(commandClass);

        if (hasSignalCommand(signal, commandClass))
            return;

        var signalCommandMap:Dictionary = signalMap[signal] = signalMap[signal] || new Dictionary(false);

        var callback:Function = function(a:* = null, b:* = null, c:* = null, d:* = null, e:* = null, f:* = null, g:* = null):void {
            routeSignalToGuardedCommand(signal, arguments, commandClass, oneShot, guards);
        };

        signalCommandMap[commandClass] = callback;
        signal.add(callback);
    }

    /**
     * @inheritDoc
    */
     public function mapGuardedSignalClass(signalClass:Class, commandClass:Class, guards:*, oneShot:Boolean = false):ISignal {
        var signal:ISignal = getSignalClassInstance(signalClass);
        mapGuardedSignal(signal, commandClass, guards, oneShot);
        return signal;
    }

    protected function routeSignalToGuardedCommand(signal:ISignal, valueObjects:Array, commandClass:Class, oneshot:Boolean, guardClasses:Array):void
    {

        mapSignalValues(signal.valueClasses, valueObjects);

        var guardClass:Class;
        var iLength:uint = guardClasses.length;
        for (var i:int = 0; i < iLength; i++) {
            guardClass = guardClasses[i];
            var nextGuard:Object = injector.instantiate(guardClass);
            if (! nextGuard.approve()) {
                unmapSignalValues(signal.valueClasses, valueObjects);
                return;
            }
        }

        var command:Object = injector.instantiate(commandClass);
        unmapSignalValues(signal.valueClasses, valueObjects);
        command.execute();

        if (oneshot)
            unmapSignal(signal, commandClass);

    }

    protected function verifyGuardClasses(guardClasses:Array):void {
        var iLength:uint = guardClasses.length;
        var guardClass:Class;
        for (var i:int = 0; i < iLength; i++) {
            guardClass = guardClasses[i];
            if (!verifiedGuardClasses[guardClass]) {
                verifiedGuardClasses[guardClass] = describeType(guardClass).factory.method.(@name == "approve").length();
                if (!verifiedGuardClasses[guardClass])
                    throw new ContextError(E_GUARD_NOIMPL + ' - ' + guardClass);
            }
        }

    }

}
}