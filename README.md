# WC3-Inventory

W3-Inventory is an [AutoHotKey][1] script for Blizzard's Warcraft III, used for easier inventory access.

W3-Inventory improves inventory accessibility by binding the default inventory hotkeys (NumPad 1, 2, 4, 5, 7, 8) used by Warcraft III to another hotkey/hotkey combination. This can also provide inventory hotkeys for keyboards lacking a numpad.

## Usage

Download [AutoHotkey][2]. There is an installer version and a portable version. The following examples we will be using the portable version.

**Note:** *W3-Inventory is created for AutoHotkey 1.1, future versions may or may not support backwards compatibility.*

### Running the script directly

To run the script use the following command

```shell
AutoHotkey.exe path-to-file\W3-Inventory-Gui.ahk
```
Where *AutoHotkey.exe* is the Unicode version of the AutoHotkey executable. Use the right version for your system (U32 = 32-bit, U64 = 64-bit). See the [docs][3].


### Compiling into a binary

Alternatively, you can compile it into a binary and run that binary instead

```shell
Ahk2.exe /in path-to-file\W3-Inventory-Gui.ahk
```

See [AutoHotKey docs][4] for more information

### Configuring hotkeys

Configure hotkeys by clicking the box next to the inventory slot/numpad key you want to change, then pressing your desired key/key combination.

### Saving current mapping

Press the *Save Mapping* button to save the current hotkey configuration. Saved configurations are loaded when W3-Inventory is started.

### Reset to default hotkey mapping

Press the *Load Default* key to reset to the default hotkey mapping. The default mapping is:


| Inventory Slot | Original Key | Default Mapping |
|----------------|--------------|-----------------|
|Slot 1          |NumPad7       |Alt + Q          |
|Slot 2          |NumPad8       |Alt + W          |
|Slot 3          |NumPad4       |Alt + A          |
|Slot 4          |NumPad5       |Alt + S          |
|Slot 5          |NumPad1       |Alt + Z          |
|Slot 6          |NumPad2       |Alt + X          |


### Enabling the hotkeys

Press *START* to enable the hotkeys. Press *STOP* to disable it.

## Screenshot

![screenshot]

[1]: https://autohotkey.com/
[2]: https://autohotkey.com/download/
[3]: https://autohotkey.com/docs/Scripts.htm#cmd
[4]: https://autohotkey.com/docs/Scripts.htm#ahk2exe

[screenshot]: https://i.imgur.com/pr7aUlm.png?1