#  -----------------
# |    NimBuster    |
#  -----------------

# For Argument Parsing
import parseopt

# For HTTP Requests
import httpcore
import httpclient

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

if url == "":
  echo "No URL provided"
  system.quit()

if wordlist == "":
  echo "No wordlist provided"
  system.quit()

let okStatusCodes = ["200 OK", "302 Redirect"]

# Open the wordlist file
let f = open(wordlist)

# Spawn an HTTP Client
var client = newHttpClient()

for line in f.lines:
  let resp = client.get(url & line)
  echo $code(resp)
  if $code(resp) in okStatusCodes:
    echo "[+] " & line & " " & $code(resp)

# Close the file when done
f.close()
