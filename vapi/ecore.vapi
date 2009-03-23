/**
 * Copyright (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 */
[CCode (cprefix = "Ecore_", lower_case_cprefix = "ecore_", cheader_filename = "Ecore.h")]
namespace Ecore
{
    public int init();
    public int shutdown();

    //=======================================================================
    [CCode (instance_pos = 0)]
    public delegate bool Callback();

    //=======================================================================
    [CCode (instance_pos = 1)]
    public delegate bool FdHandler( void* data );

    //=======================================================================
    [CCode (instance_pos = 1)]
    public delegate bool BufHandler( void* data );

    //=======================================================================
    namespace MainLoop
    {
        void iterate();
        void begin();
        void quit();

        [CCode (cname = "ecore_main_fd_handler_add")]
        FdHandler fd_handler_add( int fd, FdHandlerFlags flags, FdHandler fd_func, BufHandler buf_func );
    }

    //=======================================================================
    [CCode (cprefix = "ECORE_FD_")]
    public enum FdHandlerFlags
    {
        READ,
        WRITE,
        ERROR,
    }

    //=======================================================================
    [CCode (cprefix = "ECORE_EXE_")]
    public enum ExeFlags
    {
        PIPE_READ,
        PIPE_WRITE,
        PIPE_ERROR,
        PIPE_READ_LINE_BUFFERED,
        PIPE_ERROR_LINE_BUFFERED,
        PIPE_AUTO,
        RESPAWN,
        USE_SH,
        NOT_LEADER,
    }

    //=======================================================================
    [Compact]
    [CCode (free_function = "ecore_idler_del")]
    public class Idler
    {
        [CCode (cname = "ecore_idler_add")]
        Idler( Callback callback );
    }

    //=======================================================================
    [Compact]
    [CCode (cname = "Ecore_Idle_Enterer", free_function = "ecore_idle_enterer_del")]
    public class IdleEnterer
    {
        [CCode (cname = "ecore_idle_enterer_add")]
        IdleEnterer( Callback callback );
    }

    //=======================================================================
    [Compact]
    [CCode (cname = "Ecore_Idle_Exiter", free_function = "ecore_idle_exiter_del")]
    public class IdleExiter
    {
        [CCode (cname = "ecore_idle_exiter_add")]
        IdleExiter( Callback callback );
    }

    //=======================================================================
    [Compact]
    [CCode (cname = "Ecore_Timer", free_function = "ecore_timer_del")]
    public class Timer
    {
        [CCode (cname = "ecore_timer_add")]
        Timer( double in_, Callback callback );
        public void interval_set(double in_);
        public void freeze();
        public void thaw();
        public void delay(double add);
        public double pending_get();
        public static double precision_get();
        public static void precision_set(double precision);
    }

}
