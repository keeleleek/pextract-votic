(:~ 
 Convert an LMF Extensional Morphology resource into Paradigm Extract's
 input file format.
 
 @author Kristian Kankainen
 @copyright MTÜ Keeleleek
 :)

let $base-dir := file:parent(static-base-uri())
let $file := doc($base-dir || "votic-extensional.xml")
let $lang := $file//*:Lexicon/@language

(:~ 
 The wordforms held in the LMF occasionally uses dots as simple hyphenation marks.
 This script ignores them by simply removing all dots.
 :)
let $strip-dots := function($string) { translate($string,".", "")}


for $partofspeech in distinct-values($file//*:LexicalEntry/@partOfSpeech)
  return file:write-text(
    (: file path :)
    $base-dir || "pextract/" || $lang || "-" || $partofspeech,
    (: file content :)
    string-join(
    for $lexicalentry in $file//*:LexicalEntry[@partOfSpeech = $partofspeech]
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
                for $param in $wordform/(@* except (@writtenForm|@attestedInCorpus|@attested))
                  return concat($param/local-name(), "=", $param/data())
                , ",")
            )
           , out:nl() )
           || out:nl()
      )
    , out:nl())
  )