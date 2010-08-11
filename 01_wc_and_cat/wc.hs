
import System.Environment
import System.IO
import Data.Word
import Data.Char

main                         =  do
  args                      <-  getArgs
  return ()

wc h                         =  (fmap (foldr chew start) . hGetContents) h

jobs [ ]                     =  [return (WCJob "" stdin)]
jobs args                    =  map job args
--  You can replace all instances of `map' by `fmap'; but not the other way
--  around. Why is that? What are the type signatures of `map' and `fmap'?

job                         ::  String -> IO WCJob
job "-"                      =  return (WCJob "-" stdin)
job s                        =  WCJob s `fmap` openFile s ReadMode

{-| WCJob is a simple structure, a file and its name. It is a so-called
    product type.
 -}
data WCJob                   =  WCJob String -- ^ Name of file.
                                      Handle -- ^ Input handle.
                                       deriving (Show)

{-| The start state -- nothing counted and accepting words.
 -}
start                        =  WCState True 0 0 0

{-| WCState is the state of a counting task.
 -}
data WCState                 =  WCState Bool   -- ^ Accepting words?
                                        Word64 -- ^ Character count.
                                        Word64 -- ^ Word count.
                                        Word64 -- ^ Line count.
                                         deriving (Eq, Ord, Show)

{-| An enumeration of character types, from the point of view of WC. A simple
    sum type.
 -}
data CharCategories          =  Word | Newline | Whitespace | Other
 deriving (Eq, Ord, Show)

chew c (WCState accepting chars words lines) =
  case category c of
    Newline                 ->  WCState True chars' words (lines + 1)
    Whitespace              ->  WCState True chars' words lines
    Other                   ->  WCState accepting chars' words lines
    Word | accepting        ->  WCState False chars' (words + 1) lines
         | otherwise        ->  WCState False chars' words lines
 where
  chars'                     =  chars + 1

category c | '\n' == c       =  Newline
           | isSpace c       =  Whitespace
           | isAlphaNum c    =  Word
           | otherwise       =  Other

