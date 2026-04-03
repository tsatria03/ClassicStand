#define MyAppId "{{8DE12F2C-1FF2-46C5-B7F5-E8B2CABA3A5F}}"
#define MyAppName "ClassicStand"
#define MyAppVersion "1.8"
#define MyAppPublisher "tsatria03"
#define MyAppURL "https://tsatria03.itch.io/ClassicStand"
#define MyAppExeName "cst.exe"

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppPublisher}\{#MyAppName}\cst
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
UninstallDisplayName={#MyAppName} {#MyAppVersion}
AppMutex={#MyAppName}_Mutex
OutputDir=.
OutputBaseFilename=ClassicStand_windows_installer_password_is_LemonPledge
Password=LemonPledge
Encryption=yes
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"
Name: "startmenuicon"; Description: "Create a Start Menu shortcut"; GroupDescription: "Additional icons:"

[Files]
Source: "C:\Users\tonys\OneDrive\Documents\GitHub\ClassicStand\releases\windows\ClassicStand_windows_portable_password_is_LemonPledge\cst\*"; \
  DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: startmenuicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; \
  Flags: nowait postinstall skipifsilent unchecked;
