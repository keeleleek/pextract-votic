(:~ 
 Convert an LMF Extensional Morphology resource into Paradigm Extract's
 input file format.
 
 @author Kristian Kankainen
 @copyright MTÜ Keeleleek
 :)

let $file := doc("./votic-extensional.xml")

(:~ 
 The wordforms held in the LMF occasionally uses dots as simple hyphenation marks.
 This script ignores them by simply removing all dots.
 :)
let $strip-dots := function($string) { translate($string,".", "")}

for $lexicalentry in $file//*:LexicalEntry
  (: use singular nominative as a filler form missing wordforms :)
  let $missing-form := $lexicalentry/*:WordForm[@grammaticalNumber="singular"
                                                                   and @grammaticalCase="nominative"]/@writtenForm/data()
  
  return (
    string-join(
      for $wordform in $lexicalentry/*:WordForm
        let $written-form := $strip-dots($wordform/@writtenForm/data())
        (: the written form can be missing, use $missing-form instead :)
        let $representation := if($written-form = "") then($missing-form) else($written-form)
        return concat(
          (: $strip-dots($lemma), :)
          $representation,
          out:tab(),
          string-join(
            for $param in $wordform/(@* except (@writtenForm|@attestedInCorpus))
              return concat($param/local-name(), "=", $param/data())
            , ",")
        )
       , out:nl() )
       || out:nl()
  )
