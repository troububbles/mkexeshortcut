# mkexeshortcut
A bash script and service menu option for generating desktop shortcuts from Windows executables on Linux.
Usage: *mkexeshortcut \<executable\> \<output folder\>*

### Dependency
icoutils - https://github.com/rwmjones/icoutils

### Installation
Run the file *install.sh*, or copy the source directory contents to *~/.local/share/kservices5/mkexeshortcut*. To install for all users, copy the contents to */usr/share/kservices5/mkexeshortcut* instead.

### Localization
Several locales are supported for the translation of the context menu option and for the generated desktop shortcut comment. Most translations were added according to Google Translate results, which may be innacurate, but an effort was made to make sure they are correctly in the context. If you spot any translation mistakes, please report and it will be corrected. You are also free to request the addition of new localizations.

The currently supported locales are:

* ar - Arabic
* cs - Czech
* da - Danish
* de - German
* el - Greek
* en - English
* es - Spanish
* fi - Finnish
* fr - French
* it - Italian
* hi - Hindi
* hu - Hungarian
* hy - Armenian
* id - Indonesian
* is - Icelandic
* lt - Lithuanian
* nl - Dutch
* pl - Polish
* pt - Portuguese
* ru - Russian
* sv - Swedish
* th - Thai
* uk - Ukrainian
* vi - Vietnamese
* zh - Chinese (Traditional)

### License
Copyright (C) 2022 Félix Dionísio Xavier Pedro

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
