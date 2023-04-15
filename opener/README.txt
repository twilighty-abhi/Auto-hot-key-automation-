Documentation for The Opener

Newest Release:
9/1/08
Initial Release:
5/11/07
  by Patrick Lannigan
  aka TheIrishThug

The Opener is a fully customizable window that allows the user to select a variety of user defined
applications to launch. The user has the option to have any number of Radio groups and one group of
Checkboxes.

New for v.2:
  If you already have an existing configuration, you will need to run updater.ahk.
  This will ask you to select the configuration file you want to update. This will then make
  the necessary changes to the configuration file you selected.
  
  You can now have multiple separate configuration files in the same folder. Configuration files
  MUST have the .ini extension.
  -If you only have one configuration file (excluding sample.ini), the one file will be loaded.
  -If you have multiple files, you will be asked to select the file you want to use. Here you will
    also be given the option to start a new configuration file. You can return to this window by
    clicking the Select Setup button.
  -If you have multiple files and want to skip directly to a specific configuration, pass the file
    name as a command line argument when you launch opener. This will work on the command line or in
    a shortcut.
    
  You are no longer restricted to one checkbox group. Use the Edit Group window to specify a type for
  each group you have made. This type will be displayed when you select the group number to help you
  edit your configuration.
  
  You can now have more than one group in a column. By clicking the Edit Positioning button, you will
  be able to select the maximum number of items that can appear in one column.
  -If you have three groups with two items per column each and you set this number to 6,
    the three groups will appear in one column.
  -If you have three groups with two items per column each and you set this number to 5,
    the three groups will appear in two columns, with only the third group in the second column.

To view the sample, rename of sample.ini to opener.ini. sample.ini should produce a Window that
looks like sample.jpg.

To configure what applications can be launched or how they are displayed, click the Edit Setup
button. If it is the first time you have run The Opener or your setup file cannot be found, you will
be brought directly to the setup window. If you force the script to close while you are editing the
setup, it will corrupt your settings and the window will not display properly the next time you open
The Opener.

For each item (program or file you would like to launch), there are various settings and information
that needs to be filled out.
Name: The text that will appear in The Opener's window.
Window Title: Part or all of the text that will be in the window title of the item you are
  launching. This is used to prevent attempts to open an item that already exist. Some mistakes can
  be made if the Window Title is two simple and might match other items. AHK class names are
  supported, but ahk_class must be included in the Window Title (see Windows Explorer in sample).
  You can also check against a process name using this field. In order to use a process name instead
  of window title, put "ProcTitle|" (case sensitive) at the beinging of the field and place the process
  name directly after the bar, no spaces (see Calculator in sample).
Default: This item will automatically be selected when The Opener creates the window (see None in
  sample).
Minimize: This item will be launched, but will be minimized instead of showing the item's window
  (see Notepad in sample). Some applications will not respond to this option (see Calculator in sample).
Location: This the location of the item you want to launch. Click the Select button to open a window
  the will let you browse to the correct folder.
Type: The type of selection you want the item to appear as. All Checkboxes will be grouped in one
  area. Radio groups must be setup by the user as only one item per radio group can be selected.
Group: The group number you want you Radio item to belong to. For direction on setting up the
  groups, read the Editing Groups section bellow.
Priority: Set the item's process priority.
Command Line Arguments: Arguments to use when running the program.
Run Code: Have one or more AutoHotkey scripts run after the item has been launched. The Opener does
  wait for half a second after launching an item, but this does not ensure that the item has fully
  loaded by the time a script is called, so it is suggested that the various WinWait commands should
  be used if your script interacts directly with the window of the item you just launched. The
  script(s) are run as new AutoHotkey processes and The Opener will move onto any other items
  without waiting for the scripts to end or being held up by errors in the script.
  To add a script or change the script(s) that will be run, click the Select button. Add script will
  open a window to select an AutoHotkey script. Remove will remove the selected script from the
  list. Closing the Edit Script List window with Done or the red X will save the list of scripts.

Other Button:
Edit Selected: Allows the user to edit the information of the selected item from the list.
Remove Selected: Will remove the selected item from the list.
Save Edits: If the user had pressed Edit Selected, the information in the above fields will be saved
  to the same item that was being edited. If the information was not based on a previous item, the
  info will be save as a new item at the bottom of the list. If you are editing an item and do not
  click save edits, those edits will be lost.
Move Selected Up/Down: Moves the selected item one space in the specified direction. Items in The
  Opener window are ordered by the Radio group number, and then by the order they appear on the
  list. The Checkbox group will always be last, and the Checkbox items will be ordered based on how
  they appear on the list. An items position on the list only matters in relation to items in the
  same group. Inter mingling Checkboxes with Radios or Radios of different groups have no effect.
Save & Close: Saves all changes to the list. If you edited the list or one item and want to cancel
  those alterations, click the red X and then acknowledge that you do not want to save the edits.
  The Opener window will re-appear with the changes the user saved. 

Editing Groups:
Edit Groups: This button brings up the Edit Group Settings window.
If the user wants to have a Checkbox group, Checkbox Group must be checked. This makes Checkbox Name
and Column Count editable. Checkbox Name is the name that will be displayed for the Checkbox group.
Column Count specifies how many columns to use when building the group. The number of items per
column will automatically be set by how many items are in the group.
Group Name and Column Count are the same as above, but pertain to the Radio groups. This part of the
window works much like the Edit Items window did. Edit will edit the selected group. Save will save
the edits back to the list. New groups will be added to the end of the list. Move Up/Down edits
the order in which the groups will appear. Cancel abandons the changes, Done saves them.

