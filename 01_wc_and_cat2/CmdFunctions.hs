module CmdFunctions where

import System.IO
import System.Environment
import System.Exit

readHandleWithPath :: String -> IO (String, Handle)
readHandleWithPath []  = error "No arguments." >> exitFailure 
readHandleWithPath "-" = return ("stdin", stdin)
readHandleWithPath f   = do
                            file <- openFile f ReadMode
                            return (f, file)

getReadHandles :: IO [(String, Handle)]
getReadHandles = do
                    args <- getArgs
                    mapM readHandleWithPath args

execute :: ((String, Handle) -> IO a) -> IO [a]
execute f = do
               handles <- getReadHandles
               mapM f handles

execute_ :: ((String, Handle) -> IO a) -> IO ()
execute_ f = do
               handles <- getReadHandles
               mapM_ f handles

