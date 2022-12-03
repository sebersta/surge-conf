use framework "Foundation"
use scripting additions

property File : POSIX path of "" # The config file is somewhere in ~/Library/Application\ support/surge/profiles/yourfilehere.conf
property Airport : POSIX path of ""
property AnotherAirport : POSIX path of ""

on run {}
	
	-- Download nodelist from airport
	updateTextFile("your link here", Airport)
	updateTextFile("your link here", AnotherAirport)
	
	
	-- Log time
	set t to "# updated on " & (time string of (current date))
	writeTextToFile(t & return, File, true)
	
	-- Write the header
	writeTextToFile("[Proxy]" & return, File, false)
	
	-- write Airport
	set temptxt to read Airport
	writeTextToFile(temptxt & return, File, false)
	
	-- write AnotherAirport
	set temptxt to read AnotherAirport
	writeTextToFile(temptxt & return, File, false)
	
	-- check
	FindandReplace("🇨🇳", "🇹🇼", File)
	deleteLinesFromFile(FileDestne, {"", "", "", "", "", ""})
	
end run


on updateTextFile(sourceURL, textFilePath) -- Download text from url and write it into a file
	set |⌘| to current application
	set sourceURL to |⌘|'s class "NSURL"'s URLWithString:(sourceURL)
	-- Download the text from the URL
	set {theText, anyError} to |⌘|'s class "NSString"'s stringWithContentsOfURL:(sourceURL) usedEncoding:(missing value) |error|:(reference)
	if (anyError is missing value) then
		-- Ensure that the destination folder exists.
		set destinationURL to |⌘|'s class "NSURL"'s fileURLWithPath:(textFilePath)
		set destinationFolderURL to destinationURL's URLByDeletingLastPathComponent()
		tell |⌘|'s class "NSFileManager"'s defaultManager() to ¬
			createDirectoryAtURL:(destinationFolderURL) withIntermediateDirectories:(true) attributes:(missing value) |error|:(missing value)
		-- Write the text to the file, creating the file if it doesn't exist, overwriting it if it does.
		set {success, anyError} to theText's writeToURL:(destinationURL) atomically:(true) encoding:(|⌘|'s NSUTF8StringEncoding) |error|:(reference)
	else
		-- Problem downloading the text.
		set errMsg to anyError's localizedDescription() as text
		display dialog errMsg buttons {"Stop", "Continue …"} cancel button 1
	end if
end updateTextFile


on FindandReplace(stringToFind, stringToReplace, thefile) -- Find and Replace a string in a text file
	set theContent to read thefile as «class utf8»
	set {oldTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, stringToFind}
	set ti to every text item of theContent
	set AppleScript's text item delimiters to stringToReplace
	set newContent to ti as string
	set AppleScript's text item delimiters to oldTID
	try
		set fd to open for access thefile with write permission
		set eof of fd to 0
		write newContent to fd as «class utf8»
		close access fd
	on error
		close access thefile
	end try
end FindandReplace


on writeTextToFile(theText, thefile, overwriteExistingContent)
	try
		set fileDescriptor to open for access thefile with write permission
		if overwriteExistingContent is true then set eof of fileDescriptor to 0
		write theText to fileDescriptor starting at eof
		close access fileDescriptor
	on error
		try
			close access fileDescriptor
		end try
	end try
end writeTextToFile

on deleteLinesFromFile(thefile, deletePhrases)
	set theText to read thefile
	repeat with deletePhrase in deletePhrases
		set newText to ""
		try
			-- here's how you can delete all lines of text fron fileText that contain the deletePhrase.
			-- first turn the text into a list so you can repeat over each line of text
			set textList to paragraphs of theText
			
			-- now repeat over the list and ignore lines that have the deletePhrase
			repeat with i from 1 to count of textList
				set thisLine to item i of textList
				if thisLine does not contain deletePhrase then
					set newText to newText & thisLine & return
				end if
			end repeat
			if newText is not "" then set newText to text 1 thru -2 of newText
		on error
			set newText to theText
		end try
		set theText to newText
	end repeat
	writeTextToFile(newText, thefile, true)
end deleteLinesFromFile
