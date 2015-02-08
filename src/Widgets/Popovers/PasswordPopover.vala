/***
  Copyright (C) 2014-2015 Switchboard User Accounts Plug Developer
  This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License version 3, as published
  by the Free Software Foundation.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranties of
  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
  PURPOSE. See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program. If not, see http://www.gnu.org/licenses/.
***/

namespace SwitchboardPlugUserAccounts.Widgets {
    public class PasswordPopover : Gtk.Popover {
        private unowned Act.User       user;
        private Gtk.Grid                main_grid;
        private Widgets.PasswordEditor  pw_editor;
        private Gtk.Button              button_change;
        //private Gtk.Button            button_cancel;

        public signal void request_password_change (Act.UserPasswordMode mode, string? new_password);

        public PasswordPopover (Gtk.Widget relative, Act.User user) {
            this.user = user;
            set_relative_to (relative);
            set_position (Gtk.PositionType.TOP);
            set_modal (true);

            build_ui ();
        }

        private void build_ui () {
            main_grid = new Gtk.Grid ();
            main_grid.hexpand = true;
            main_grid.margin = 12;
            main_grid.row_spacing = 10;
            add (main_grid);

            pw_editor = new Widgets.PasswordEditor ();
            pw_editor.validation_changed.connect (() => {
                if (pw_editor.is_valid && pw_editor.is_authenticated)
                    button_change.set_sensitive (true);
                else
                    button_change.set_sensitive (false);
            });
            main_grid.attach (pw_editor, 0, 0, 1, 1);

            Gtk.Box button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            button_box.hexpand = true;
            button_box.halign = Gtk.Align.END;
            main_grid.attach (button_box, 0, 1, 1, 1);

            button_change = new Gtk.Button.with_label (_("Change Password"));
            button_change.set_sensitive (false);
            button_change.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            button_change.set_size_request (100, 25);
            button_change.clicked.connect (() => {
                if (pw_editor.is_valid)
                    request_password_change (Act.UserPasswordMode.REGULAR, pw_editor.get_password ());

                hide ();
                destroy ();
            });
            button_box.pack_end (button_change);

            show_all ();
        }
    }
}
