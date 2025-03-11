#Requires -PSEdition Core
Set-StrictMode -Version Latest

# -split options
$splitOptions = [Environment]::NewLine

# raw wishlists
# https://github.com/search?o=desc&q=dim+wishlist&s=updated&type=Repositories
$wishlists =
(@'
https://raw.githubusercontent.com/tjames192/dim-wishlist/main/trashlist.txt
https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/voltron.txt
https://raw.githubusercontent.com/Geldarion/DIM-wishlist/main/wishlist.txt
https://raw.githubusercontent.com/ahojsvet/dim-private-wishlist/main/dimwishlist.txt
https://raw.githubusercontent.com/Zephyrr29/DIM-Wishlist/main/wishlist.txt
https://raw.githubusercontent.com/MalkToast/DIMWishList/main/TheList.txt
https://raw.githubusercontent.com/Lucys-Guardians/DIM-Wishlist/main/Lucys_DIM_recommendations_.txt
https://raw.githubusercontent.com/eksboxgirl/owl-wishlist/main/season_20.txt
https://raw.githubusercontent.com/Hiplok/DIM-wishlist/main/wishlist
https://raw.githubusercontent.com/tyhal/d2-wishlists/main/pop-wishlist.txt
https://raw.githubusercontent.com/nilsbtr/dim_wishlist/main/wishlist.txt
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Exotics
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/PvP
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Kinetic%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Kinetic%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Arc%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Arc%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Solar%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Solar%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Stasis%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Stasis%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Strand%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Strand%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Void%3A%20Other
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Void%3A%20Synergy
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Utility%3A%20Adaptive%20Munitions
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Utility%3A%20DPS
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Utility%3A%20Osmosis
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Crucible.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Raids-and-Dungeons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Special-Events.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Vanguard-and-Gambit.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Y3-Shadowkeep.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Y4-Beyond-Light.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Y5-The-Witch-Queen.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Y6-Lightfall.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/refs/heads/main/Y7-The-Final-Shape.txt
'@) -split $splitOptions
# changed from .split to -Split
# https://github.com/PowerShell/PowerShell/issues/12094

# load all the data
$results = [System.Text.StringBuilder]""

foreach ($url in $wishlists) {
	try {
		$string = Invoke-RestMethod $url
		$null = $results.AppendLine($string)
	}
	catch {
		$user = $url.split('/')[3]
		$verboseMsg = "Check https://github.com/{0}?tab=repositories" -f $user
		$warningMsg = "Not able to connect to {0}" -f $url
		
		write-warning $warningMsg
		write-verbose $verboseMsg -verbose
	}
}

# ensure line endings with newlines
$lines = $results.ToString() -split $splitOptions

# setup regex pattern and options
$RegexOptions = [Text.RegularExpressions.RegexOptions]::NonBacktracking
$RegexPattern = 'dimwishlist:item=[-|\d+]*&perks=[\d+|,]*|dimwishlist:item=[-|\d+]*'
$regex = [System.Text.RegularExpressions.Regex]::new($RegexPattern,$RegexOptions)

# save matched lines starting with dimwishlist:item
$lines = $regex.matches($lines).value

# remove dupes
$hash = [ordered]@{}

foreach ($line in $lines) {
	if (-not $hash.contains($line)) {
		$null = $hash.add($line, $null)
	}
}
	
# export
$title = 'title:This is a compiled collection of god/recommended rolls from community minds.'
$description = 'description: https://github.com/search?o=desc&q=dim+wishlist&s=updated&type=Repositories'

# unix line ending + UTF ensures smaller file size 
$unixlines = ($title, $description -join "`n") + ($hash.keys -join "`n")
Set-Content -Path wishlist.txt -Value $unixlines -Encoding UTF8 -NoNewline
# ideally wishlist should be less than 25MB to upload to GitHub

# print unique rolls count
$rollsCount = $hash.keys.count.ToString("#,##0")
"{0} rolls in your wish list" -f $rollsCount
