package org.robotlegs.test.support
{
    import org.robotlegs.core.IInjector;
    import org.robotlegs.mvcs.SignalContext;

    public class SignalContextWithAccessibleInjector extends SignalContext
{
    public function SignalContextWithAccessibleInjector()
    {
        super();
    }

    public function getInjector():IInjector
    {
        return injector;
    }
}
}