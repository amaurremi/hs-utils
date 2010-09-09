
module HSUtils.WC.Options where


import Text.Parsec (tokenPrim, incSourceLine, Stream, ParsecT)


data Option                  =  Chars | Lines | Words | Help | Version
 deriving (Eq, Ord, Show)


{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Because we're using strings in our WC, we omit the option to count bytes
  (instead of chars). We also ignore some of the fancier options.

       -m, --chars
              print the character counts

       -l, --lines
              print the newline counts

       -w, --words
              print the word counts

       --help display this help and exit

       --version
              output version information and exit

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}



{-| With this primitive string token definition, we can use Parsec on streams
    of strings (instead of streams of chars).
 -}
string                      ::  (Eq String, Show String, Stream s m String)
                            =>  String -> ParsecT s u m String
string s                     =  tokenPrim show nextPos idTest
 where
  idTest s'                  =  if s == s' then Just s else Nothing
  nextPos pos _ _            =  incSourceLine pos 1

