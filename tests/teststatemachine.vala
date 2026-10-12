using EflVala;

class TestViewState : ViewState
{
    public int activated_count = 0;
    public int deactivated_count = 0;

    public TestViewState(ViewStateMachine machine)
    {
        base(machine);
    }

    public override void activated()
    {
        activated_count++;
    }

    public override void deactivated()
    {
        deactivated_count++;
    }
}

public void test_state_transitions()
{
    var machine = new ViewStateMachine.headless();
    var initial = new TestViewState(machine);
    var next = new TestViewState(machine);

    machine.state_register(null);
    machine.state_register(initial);
    machine.state_register(next);
    initial.transition_add("continue", next);

    machine.current_state_set(initial);
    assert(initial.activated_count == 1);
    assert(initial.deactivated_count == 0);

    machine.emit("missing");
    assert(initial.activated_count == 1);
    assert(initial.deactivated_count == 0);

    machine.emit("continue");
    assert(initial.deactivated_count == 1);
    assert(next.activated_count == 1);
}

void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/ViewState/Transitions", test_state_transitions);
    Test.run();
}