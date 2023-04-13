# raw wishlists
# https://github.com/search?o=desc&q=dim+wishlist&s=updated&type=Repositories
$wishlists =
(@'
https://raw.githubusercontent.com/tjames192/dim-wishlist/main/wishlist.txt
https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/voltron.txt
https://raw.githubusercontent.com/tyhal/d2-wishlists/main/pop-wishlist.txt
https://raw.githubusercontent.com/nilsbtr/dim_wishlist/main/wishlist.txt
https://raw.githubusercontent.com/liminalAce/wishlists/main/Alpacas_PVE_Raid_Rolls.txt
https://raw.githubusercontent.com/liminalAce/wishlists/main/datto_lightfall.txt
https://raw.githubusercontent.com/liminalAce/wishlists/main/perkstokeep.txt
https://raw.githubusercontent.com/Lucys-Guardians/DIM-Wishlist/main/Lucys_DIM_recommendations_.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Trials-of-Osiris-Weapons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/30th-Anniversary.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Iron-Banner-Weapons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Nightfall-Weapons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Raid-Weapons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Special-Event-Weapons.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-Arrivals.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-Defiance
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-Plunder.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-The-Lost.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-The-Seraph.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-The-Splicer.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-the-Chosen.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-the-Haunted.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-the-Hunt.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-the-Risen.txt
https://raw.githubusercontent.com/ace51689/DIM-wishlist/main/Season-of-the-Worthy.txt
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Exotic%20Search%20Tags
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/General%20Perks
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Auto%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Combat%20Bow
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Fusion%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Glaive
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Hand%20Cannon
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Heavy%20Grenade%20Launcher
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Linear%20Fusion%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Machine%20Gun
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Pulse%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Rocket%20Launcher
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Scout%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Shotgun
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Sidearm
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Sniper%20Rifle
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Special%20Grenade%20Launcher
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Submachine%20Gun
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Sword
https://raw.githubusercontent.com/Gix3612/DIM-Wishlist/main/Trace%20Rifle
'@).Split([Environment]::NewLine).where({$_})

# load all the data
$data = [System.Text.StringBuilder]""

foreach ($url in $wishlists) {
	$results = (Invoke-RestMethod $url).Split([Environment]::NewLine)
	
	foreach ($line in $results) {
		$null = $data.AppendLine($line)
	}
}

# cleanup
$data = $data.ToString().Split([Environment]::NewLine)
$data = $data.where({$_.startswith("dimwishlist")})
$data = $data.where({-not $_.contains("cannot random roll")})

# remove dupes
$hash = [ordered]@{}

foreach ($line in $data) {
	if (-not $hash.contains($line)) {
		$null = $hash.add($line, $null)
	}
}
	
# export
$hash.keys > wishlist.txt
# ideally wishlist should be less than 25MB to upload to GitHub

Remove-Variable -Name hash -ErrorAction SilentlyContinue
Remove-Variable -Name data -ErrorAction SilentlyContinue

exit