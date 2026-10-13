using GLib;

public class EflVala.ViewState
{
    protected ViewStateMachine state_machine;
    protected Gee.HashMap<string, ViewState> transition_map = null;

    public ViewState(ViewStateMachine sm)
    {
        transition_map = new Gee.HashMap<string, ViewState>();
        this.state_machine = sm;
    }

    public void transition_add(string transition, ViewState next)
    {
        transition_map[transition] = next;
    }

    public ViewState? transition_handle(string condition)
    {
        return transition_map[condition];
    }

    public virtual void activated()
    {
    }

    public virtual void deactivated()
    {
    }

    public virtual unowned Elm.Object? object_get()
    {
        return null;
    }
}

public class EflVala.ViewStateMachine
{
    // Elm.Pager was removed from Elementary (EFL 1.22); Naviframe is the
    // replacement, so this uses the native binding directly.
    private Elm.Naviframe? naviframe;
    private Gee.ArrayList<weak Elm.ObjectItem> items = new Gee.ArrayList<weak Elm.ObjectItem>();
    private Gee.HashMap<weak Elm.Object, weak Elm.ObjectItem> item_map =
        new Gee.HashMap<weak Elm.Object, weak Elm.ObjectItem>();
    private ViewState current_state;

    public ViewStateMachine(Elm.Win win)
    {
        current_state = null;

        naviframe = new Elm.Naviframe(win);
        win.resize_object_add(naviframe);
        naviframe.show();
    }

    public ViewStateMachine.headless()
    {
        current_state = null;
    }

    public new void state_register(ViewState? state)
    {
        if(state == null)
            return;

        unowned Elm.Object? content = state.object_get();
        if(content == null || naviframe == null)
            return;

        // naviframe only reveals its top item, so hide the content here
        // (the old elm_pager_content_push compat shim did the same).
        content.hide();
        unowned Elm.ObjectItem? item = naviframe.item_simple_push(content);
        if(item != null)
        {
            items.add(item);
            item_map[content] = item;
        }
    }
    
    public void current_state_set(ViewState state)
    {
        if(current_state != null)
            current_state.deactivated();
        current_state = state;
        current_state.activated();
    }

    public void emit(string condition)
    {
        ViewState new_state = null;

        if(current_state == null) 
        {
            debug("no current state!");
            return;
        }

        new_state = current_state.transition_handle(condition);
        if(new_state != null)
            current_state_set(new_state);
 
        // promote the current state's view to the top of the stack,
        // replacing the old elm_pager_content_promote compat shim.
        unowned Elm.Object? content = ((ViewState)current_state).object_get();
        if(content != null && naviframe != null && item_map.has_key(content))
            item_map[content].promote();
    }
}


