**MakeMeDefaultApp**

by Damian Fornagiel




**Introduction**

MakeMeDefaultApp is an open source script that provides administrators with a comprehensive solution to enforce specific application be a default app for specific file type




**Usage:**
  --fileExtension <extension>   File extension (e.g., pdf)
  --bundleID <bundle_id>        Application bundle identifier (e.g., com.adobe.Acrobat.Pro)
  --help                        Show this help message

Example:
  /Library/Management/MakeMeDefaultApp/MakeMeDefaultApp --fileExtension pdf --bundleID com.adobe.Acrobat.Pro

You must run the script as the logged-in user when executing it via MDM:

userName=$(stat -f "%Su" /dev/console); userID=$(id -u "$userName"); launchctl asuser "$userID" sudo -u "$userName" /Library/Management/MakeMeDefaultApp/MakeMeDefaultApp --fileExtension pdf --bundleID com.adobe.Acrobat.Pro
