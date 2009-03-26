/**
 * Copyright (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

// misc objects that need to get categorized

//=======================================================================
public class EflVala.Command : GLib.Object
//=======================================================================
{
    public string command;

    public Command( string command )
    {
        this.command = command;
        debug( "creating command '%s' (%p)", command, this );
    }

    ~Command()
    {
        debug( "destructing command '%s' (%p)", this.command, this );
    }
}

//=======================================================================
public class EflVala.BidirectionalThreadQueue : GLib.Object
//=======================================================================
{
    public enum Identifier
    {
        COMMUNICATION_THREAD,
        GUI_THREAD;
    }
    private static EflVala.QueueWithNotifier<Command> toGuiQ;
    private static EflVala.QueueWithNotifier<Command> toCommQ;

    private Identifier owner;

    public BidirectionalThreadQueue( Identifier id )
    {
        owner = id;
        switch ( id )
        {
            case Identifier.COMMUNICATION_THREAD:
                assert ( toGuiQ == null );
                toGuiQ = new EflVala.QueueWithNotifier<Command>();
                break;
            case Identifier.GUI_THREAD:
                assert ( toCommQ == null );
                toCommQ = new EflVala.QueueWithNotifier<Command>();
                break;
            default:
                assert_not_reached();
        }
    }

    public void getFds( out int readfd, out int writefd )
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                readfd = toCommQ.getReadFd();
                writefd = toGuiQ.getWriteFd();
                break;
            case Identifier.GUI_THREAD:
                readfd = toGuiQ.getReadFd();
                writefd = toCommQ.getWriteFd();
                break;
            default:
                assert_not_reached();
        }
    }

    public int getReadFd()
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                return toCommQ.getReadFd();
                break;
            case Identifier.GUI_THREAD:
                return toGuiQ.getReadFd();
                break;
            default:
                assert_not_reached();
        }
    }

    public Command? read()
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                return toCommQ.read();
                break;
            case Identifier.GUI_THREAD:
                return toGuiQ.read();
                break;
            default:
                assert_not_reached();
        }
    }

    public void write( Command command )
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                toGuiQ.write( command );
                break;
            case Identifier.GUI_THREAD:
                toCommQ.write( command );
                break;
            default:
                assert_not_reached();
        }
    }

}
