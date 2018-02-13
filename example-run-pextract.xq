import module namespace pfile = 'http://keeleleek.ee/pextract/pfile' at '/home/kristian/Projektid/marfors/pextract-xml/lib/pfile.xqm';

let $pextract-py := "/home/kristian/Projektid/marfors/paradigmextract/src/pextract.py"
let $folder := "/home/kristian/Projektid/pextract-votic/pextract/"

let $pextractor := pfile:pextract-cmd($pextract-py, ?, ?, "UTF-8")

for $file in ($folder||"vot-commonNoun")
  let $file-name := file:name($file)
  
  return $pextractor($file, $folder || $file-name || ".p")