
{-# LANGUAGE FlexibleContexts
           , NoMonomorphismRestriction
  #-}

module HSUtils.WC.Options where


import Prelude hiding (words, lines)
import System.Environment
import Data.Set
import Control.Arrow

import Text.Parsec hiding (string, option)


getOptionsAndArgs           ::  IO (Either ParseError (Set Option, [String]))
getOptionsAndArgs =
  runP optionsAndArgs (Data.Set.empty, []) "<argv>" `fmap` getArgs

optionsAndArgs = choice [ eof >> fmap (second reverse) getState
                        , optionOrArgWithState >> optionsAndArgs ]

optionOrArgWithState         =  do
  res                       <-  optionOrArg
  modifyState $ case res of
    Left option             ->  first (insert option)
    Right string            ->  second (string:)

optionOrArg :: (Stream s m String) => ParsecT s u m (Either Option String)
optionOrArg = choice [Left `fmap` option, Right `fmap` anyString]


{-| Invidual WC options, though not all of them. In particular, we omit the
    option to count bytes since we're using Haskell strings.
 -}
data Option                  =  Chars   -- ^ print the character counts
                             |  Lines   -- ^ print the newline counts
                             |  Words   -- ^ print the word counts
                             |  Help    -- ^ display this help and exit
                             |  Version -- ^ output version information and exit
                               deriving (Eq, Ord, Show)

option                       =  choice [chars, lines, words, help, version]

chars                        =  strings ["-m", "--chars"] >> return Chars
lines                        =  strings ["-l", "--lines"] >> return Lines
words                        =  strings ["-w", "--words"] >> return Words
help                         =  strings ["--help"]        >> return Help
version                      =  strings ["--version"]     >> return Version



string :: (Stream s m String) => String -> ParsecT s u m String
string s                     =  stringTest idTest
 where
  idTest s'                  =  if s == s' then Just s else Nothing

strings :: (Stream s m String) => [String] -> ParsecT s u m String
strings                      =  choice . fmap (try . string)

anyString                   ::  (Stream s m String) => ParsecT s u m String
anyString                    =  stringTest Just

{-| Bootstraps our string parser (we work with streams of strings as opposed
    to streams of chars).
 -}
stringTest :: (Stream s m String) => (String -> Maybe t) -> ParsecT s u m t
stringTest test              =  tokenPrim show nextPos test
 where
  nextPos pos _ _            =  incSourceLine pos 1

