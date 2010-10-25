
import System.IO
import CmdFunctions


main :: IO ()
main =  execute_ cat

cat :: (String, Handle) -> IO ()
cat (_, handle) = do
                     s <- hGetContents handle
                     hPutStr stdout s
