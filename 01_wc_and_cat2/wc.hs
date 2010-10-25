
import System.IO
import System.Exit
import Data.List (transpose, intersperse)
import CmdFunctions


main :: IO ()
main = do
          results <- execute wc
          run results

wc :: (String, Handle) -> IO ([Int], FilePath)
wc (fileName, handle) = do
           content <- hGetContents handle
           wc' content
                where wc' :: String -> IO ([Int], FilePath)
                      wc' content = let lengthFContent f = length $ f content
                                    in  return ([lengthFContent lines,
                                                 lengthFContent words,
                                                 lengthFContent id],
                                                fileName)

run :: [([Int], FilePath)] -> IO ()
run (([], _) : _) = error "No arguments" >> exitFailure -- can never happen
run [(end, _)]    = hPutStrLn stdout $ separateWithTabs (end, "total")
run pairs         = do
                       let ints = fst $ unzip pairs
                       hPutStr stdout $ unlines $ map separateWithTabs pairs
                       run [(map sum $ transpose ints, "")]

separateWithTabs :: ([Int], FilePath) -> String
separateWithTabs (ints, fileName) = concat $ intersperse "\t" $ 
                                    map show ints ++ [fileName]

