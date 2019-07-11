#  -----------------
# |    NimBuster    |
#  -----------------

# For Argument Parsing
import parseopt
import strutils

# For HTTP Requests
import httpcore
import httpclient

# For Threading
import threadpool

const okStatusCodes = ["200 OK", "302 Redirect"]

# Scan a word
proc scan_word(url: string) {.thread.}  =
  let client = newHttpClient() 
  let resp = client.get(url)
  if $code(resp) in okStatusCodes:
    echo "[+] " & url & " (" & $code(resp) & ")"

proc main() =
  # Globals
  var url = ""
  var wordlist = ""
  
  # Parse the arguments
  for kind, key, value in getOpt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "u":
        echo "[URL] " & value
        url = value
      of "w":
        echo "[WORDLIST] " & value  
        wordlist = value
      else:
        echo "Unknown option: " & key
        system.quit()
    else:
      discard
  
  # Check if the URL was provided
  if url == "":
    echo "No URL provided"
    system.quit()
  
  # Check if a wordlist was provided
  if wordlist == "":
    echo "No wordlist provided"
    system.quit()
  
  # Open the wordlist file
  let f = open(wordlist)
  
  # Fill the wordlist array
  for line in f.lines:
    spawn scan_word(url & "/" & line)
 
  sync()

  # Close the file when done
  f.close()
  

main()
