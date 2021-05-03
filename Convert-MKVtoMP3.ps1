#Created by Joris
#Date : 03-05-2021
#Requires FFMPEG (Windows Binary)
#https://github.com/FFmpeg/FFmpeg
############################################################

#Input Variables#
$path = 'G:\My Drive\Media\Muziek\Supersized Kingsday (2021)'

############################################################

$mkvfiles = Get-ChildItem ($path + '\*') -Include *.mkv

foreach ($file in $mkvfiles)
{
$shortfile = ($file.name -replace ".{4}$", ".mp3")
ffmpeg -i $file.Name -vn -c:a libmp3lame -y $shortfile #-enable-libmp3lame
}

