
import System.Environment
import System.IO
import Text.Printf
import Data.Word
import Data.Char

--  A Haskell line style comment.
{-  A Haskell range comment.
 -}

{-  Haskell's "doc comment" system is Haddock. You'll see comment delimiters
 -  followed by a `|' or a `^', before or after the documented entity.
 -}

main                         =  do
  args                      <-  getArgs
  jobs'                     <-  jobs args
  results                   <-  (sequence . map wc) jobs'
  (sequence . map display') results
 where
  display' result            =  (hPutStrLn stdout . display) result

wc                          ::  WCJob -> IO WCResult
wc (WCJob name handle)       =  do
  state                     <-  wc' handle
  return (WCResult name state)
--  Can you rewrite this function with `fmap', omitting `do' notation?

{-| Count chars, words and lines from a Handle.
 -}
wc'                         ::  Handle -> IO WCState
wc' h                        =  (fmap fold_chars . hGetContents) h
 where
  fold_chars                 =  foldr consume start
--  You can remove the `h' in the definition of `wc'', above; it makes no
--  difference. Why is that? What is the relationship between function
--  currying and partial application?

jobs paths                   =  (sequence . map job) paths
--  You can replace all instances of `map' by `fmap'; but not the other way
--  around. Why is that? What are the type signatures of `map' and `fmap'?

{-| Take a string and determine what handle and name to use. Opens a file
    unless the name is a single dash, in which case we use STDIN.
 -}
job                         ::  String -> IO WCJob
job s                        =  WCJob s `fmap` case s of
                                                 "-" -> return stdin
                                                 s   -> openFile s ReadMode
--  You can replace `fmap' with `liftM' in this case; but not always. What are
--  the type signatures of `fmap' and `liftM'?

{-| Consume a character, producing a new state.
 -}
consume c (WCState accepting chars words lines) =
  case category c of
    Newline                 ->  WCState True chars' words (lines + 1)
    Whitespace              ->  WCState True chars' words lines
    Other                   ->  WCState accepting chars' words lines
    Word | accepting        ->  WCState False chars' (words + 1) lines
         | otherwise        ->  WCState False chars' words lines
 where
  chars'                     =  chars + 1



{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  We introduce data structures for each file to be processed and the state of
  a WC parse/run. By introducing these structures, we make handling further
  processing easy and safe.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}

{-| WCJob is a simple structure, a file and its name. It is a so-called
    product type -- it is made of several fields, all of them other types.
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


data WCResult                =  WCResult String WCState
 deriving (Eq, Ord, Show)
{-  The deriving declaration is used to provide implementations of generic
 -  functions automatically. Here we are ensuring that WCResults can be
 -  compared for equality, compared for ordering (based on the ordering of the
 -  constituent fields) and displayed as a String.
 -}

display                     ::  WCResult -> String
display (WCResult s (WCState _ c w l)) = printf fmt l w c s
 where
  len                        =  ceiling (logBase 10 (fromIntegral c))
  fmt = (concat . replicate 3) ("%" ++ show len ++ "d ") ++ "%s"
--  Notice how I drill down into the fields of `WCResult' and then drill down
--  into `WCState' for its fields. In what ways is pattern matching opposed
--  to modularity?
--  Can you rewrite `len' to use `.' (compose)?


{-| An enumeration of character types, from the point of view of WC.
 -}
data CharCategories          =  Word | Newline | Whitespace | Other
 deriving (Eq, Ord, Show)

category c | '\n' == c       =  Newline
           | isSpace c       =  Whitespace
           | isAlphaNum c    =  Word
           | otherwise       =  Other

