
import System.IO
import System.Environment
import System.Exit


main                         =  do
  args                      <-  getArgs
  case args of
    [ ]                     ->  err "No argument given." >> exitFailure
    [f]                     ->  cat =<< openFile f ReadMode
    _:_                     ->  err "Too many arguments." >> exitFailure

cat handle                   =  do
  s                         <-  hGetContents handle
  hPutStr stdout s

err                          =  hPutStrLn stderr

