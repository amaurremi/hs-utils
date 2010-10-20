
import System.IO
import System.Environment
import System.Exit


main :: IO ()
main =  do
        args <- getArgs
        case args of
                  [] -> err "No argument given." >> exitFailure
                  fs -> catty fs
                        where catty []       = return ()
                              catty (f : fs) = 
                                  let doCat handle = cat handle >> catty fs 
                                  in case f of
                                         "-" -> doCat stdin
                                         _   -> doCat =<< openFile f ReadMode

main' :: IO ()
main' = do
        args <- getArgs
        case args of
                  [] -> err "No argument given." >> exitFailure
                  fs -> let getHandle f = case f of 
                                              "-" -> return stdin
                                              _   -> openFile f ReadMode
                        in mapM_ ((cat =<<) . getHandle) fs

cat :: Handle -> IO ()
cat handle = do
        s <- hGetContents handle
        hPutStr stdout s


err :: String -> IO ()
err =  hPutStrLn stderr
