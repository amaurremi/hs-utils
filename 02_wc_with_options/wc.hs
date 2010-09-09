
import System.Environment
import System.IO
import System.Exit
import qualified Data.List
import qualified Data.Set

import HSUtils.WC.Options


main                         =  do
  res                       <-  getOptionsAndArgs
  case res of
    Left parseErr           ->  do
      err ("Option parsing error: " ++ (show parseErr))
      exitFailure
    Right (options, args)   ->  do
      err $ if Data.Set.null options
        then  "No options."
        else  concat $ "Options:" : map (("\n  " ++) . show)
                                        (Data.Set.elems options)
      err $ if Data.List.null args
        then  "No arguments."
        else  concat $ "Arguments, in order:" : map (("\n  " ++) . show) args
      exitSuccess

err                          =  hPutStrLn stderr

