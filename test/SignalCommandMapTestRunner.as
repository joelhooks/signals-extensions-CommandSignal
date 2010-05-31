package {
    import asunit4.ui.MinimalRunnerUI;

    import org.robotlegs.test.suites.SignalCommandMapTestSuite;

    [SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
    public class SignalCommandMapTestRunner extends MinimalRunnerUI
    {
        public function SignalCommandMapTestRunner()
        {
            run(SignalCommandMapTestSuite);
        }
    }
}
