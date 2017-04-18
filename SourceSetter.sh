#!/bin/bash

i=0
sizes=(1800 1600 1200 900 600 300 100)
config="./sourcesetter.config"
instance="`date +%Y%m%d%H%M%S`"
export_location=exports-"$instance"
details="$export_location"/-sourcesetter.txt

# Check if config file exists
if [ -f "$config" ];
then
  # Use existing config file
  source $config
else
  # Create a new config file
  echo 'sizes=(1800 1600 1200 900 600 300 100)' > $config
fi

# Create a directory for exports
mkdir -p $export_location
# Create the detailed information text file
echo -e "Source Setter\n" > $details


# Find all .jpg files in the current directory
# find . -name '*.jpg' -o -name '*.png'
# find . -name '*.jpg' -o -name '*.png' | while IFS= read -r FILE;
find . -name '*.jpg' -maxdepth 1 | while IFS= read -r FILE;
do
  basename=${FILE##*/}
  filename="${basename%.*}"
  echo "<picture>" >> $details
  while [ $i -lt ${#sizes[@]} ];
  do
    echo "  <source media=\"(min-width: ${sizes[$i]}px)\" srcset=\"$filename-${sizes[$i]}.jpg 1x, $filename-${sizes[$i]}@2x.jpg 2x\">" >> $details
    # Export sourceset files
    cp "$basename" $export_location/"$filename"-${sizes[$i]}.jpg
    sips -Z ${sizes[$i]} $export_location/"$filename"-${sizes[$i]}.jpg
    cp "$basename" $export_location/"$filename"-${sizes[$i]}@2x.jpg
    sips -Z "$((${sizes[$i]} * 2))" $export_location/"$filename"-${sizes[$i]}@2x.jpg
    : $[ i++ ]
  done
  echo "  <img src=\"$filename.jpg\" alt=\"\">" >> $details
  echo "</picture>" >> $details
  echo -e "\n" >> $details
  i=0
done
i=0


# Find all .png files in the current directory
find . -name '*.png' -maxdepth 1 | while IFS= read -r FILE;
do
  basename=${FILE##*/}
  filename="${basename%.*}"
  echo "<picture>" >> $details
  while [ $i -lt ${#sizes[@]} ];
  do
    echo "  <source media=\"(min-width: ${sizes[$i]}px)\" srcset=\"$filename-${sizes[$i]}.png 1x, $filename-${sizes[$i]}@2x.png 2x\">" >> $details
    # Export sourceset files
    cp "$basename" $export_location/"$filename"-${sizes[$i]}.png
    sips -Z ${sizes[$i]} $export_location/"$filename"-${sizes[$i]}.png
    cp "$basename" $export_location/"$filename"-${sizes[$i]}@2x.png
    sips -Z "$((${sizes[$i]} * 2))" $export_location/"$filename"-${sizes[$i]}@2x.png
    : $[ i++ ]
  done
  echo "  <img src=\"$filename.png\" alt=\"\">" >> $details
  echo "</picture>" >> $details
  echo -e "\n" >> $details
  i=0
done