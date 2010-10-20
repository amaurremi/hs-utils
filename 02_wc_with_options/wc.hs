
import System.Environment
import System.IO
import System.Exit
import qualified Data.List
import qualified Data.Set

import HSUtils.WC.Options hiding (help, version, chars, words, lines, option)
import HSUtils.CmdFunctions (readHandleWithPath)

type FContent = String

help :: String
help = "-m, --chars     print the character counts\n" ++
       "-l, --lines     print the newline counts\n"   ++
       "-w, --words     print the word counts\n"      ++
       "--help          display this help and exit\n" ++
       "--version       output version information"

version :: String
version = "This is J&M's wc version."
       
main = do
    res                  <- getOptionsAndArgs
    case res of
         Left parseErr   -> do
             err $ "Option parsing error: " ++ (show parseErr)
             exitFailure
         Right optArgs@(options, _)   -> do
             let printy = hPutStrLn stdout
                 memberOptions = (`Data.Set.member` options)
             if memberOptions Help
                then printy help
                else if memberOptions Version
                        then printy version
                        else run =<< wc optArgs
             exitSuccess

type IsOneFile = Bool
type MaxTab    = Int

choseSeparateFunction :: MaxTab -> Bool -> (([String], FilePath) -> String)
choseSeparateFunction maxtab containsStdout = if containsStdout
    then separateWithTabs
    else separateWithSpaces maxtab

run :: [([String], FilePath)] -> IO ()
run pairs = runny pairs True $ choseSeparateFunction (maximum $ map length $ fst $ last pairs) $ elem "-" $ snd $ unzip pairs
    where runny :: [([String], FilePath)] -> IsOneFile -> (([String], FilePath) -> String) -> IO ()
          runny (([], _) : _) _ _       = error "No arguments"
          runny p@[(end, _)] isOneFile f = 
              let printy = hPutStrLn stdout . f in
                  if isOneFile
                    then printy $ head p
                    else printy (end, "total")
          runny pairs _ f              = do
                       let ints = fst $ unzip pairs
                       hPutStr stdout $ unlines $ map f pairs
                       runny [(map (show . sum) $ Data.List.transpose $ map (map ((+ 0) . read)) ints, "")] False f

err =  hPutStrLn stderr

wc :: (Data.Set.Set Option, [FilePath]) -> IO [([String], FilePath)]
wc (options, strings) = mapM (wcFile options)
                            =<< mapM readHandleWithPath strings

wcFile :: Data.Set.Set Option -> (FilePath, Handle) -> IO ([String], FilePath)
wcFile options (fileName, handle) = do
    content <- hGetContents handle
    return $ runwc options (content, fileName)

runwc :: Data.Set.Set Option -> (FContent, FilePath) -> ([String], FilePath)
runwc options (string, fileName) = 
    let lengthF f = length $ f string
        chars = map (: [])
        setIfThenElse (option, f) =
            if option `Data.Set.member` options
               then lengthF f
               else -1
    in if Data.Set.null options 
          then (map (show . lengthF) [lines, words, chars], fileName)
          else (map show $ filter (>= 0) $ map setIfThenElse 
                    [(Lines, lines), (Words, words), (Chars, chars)],
                fileName)

separateWithSpaces :: MaxTab -> ([String], FilePath) -> String
separateWithSpaces maxTab (ints, fileName) = 
    let addSpaces str = (concat . replicate (maxTab - length str)) " " 
                                                                ++ str ++ " "
    in  concat $ map addSpaces ints ++ [fileName]

separateWithTabs :: ([String], FilePath) -> String
separateWithTabs (ints@(int:is), fileName) = 
    let maxInt   = maximum (map length ints)
        tab      = if maxInt < 7
                then 7
                else maxInt
        spaces n i = (concat $ replicate (n - length i) " ") ++ i
    in  spaces tab int ++ concatMap (spaces $ tab + 1) is
              ++ " " ++ fileName

