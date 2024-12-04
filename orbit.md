## ORBIT

Step 1: Create variables!
For 0rbit's Process Id, api URL and to store incoming Data

_0RBIT = "BaMK1dfayo75s3q1ow6AO64UDpD9SEFbeE8xYrY2fyQ"
_0RBT_TOKEN = "BUhZLMwQ6yZHguLtJYA5lLUa9LQzLXMXRfaq9FVcPJc"

BASE_URL = "https://dummyjson.com/products"
FEE_AMOUNT = "1000000000000" -- 1 $0RBT

ReceivedData = ReceivedData or {}

> Step 2: Create Handlers
Get Request Handler

Handlers.add(
	"Get-Request",
	Handlers.utils.hasMatchingTag("Action", "First-Get-Request"),
	function(msg)
		Send({
			Target = _0RBT_TOKEN,
			Action = "Transfer",
			Recipient = _0RBIT,
			Quantity = FEE_AMOUNT,
			["X-Url"] = BASE_URL,
			["X-Action"] = "Get-Real-Data"
		})
		print(Colors.green .. "You have sent a GET Request to the 0rbit process.")
	end
)

Handler that will send 1 $0RBT to the 0rbit process and make the GET request for the BASE_URL

Receive Response Handler

local json = require("json")

Handlers.add(
	"ReceiveData",
	Handlers.utils.hasMatchingTag("Action", "Receive-Response"),
	function(msg)
		local res = json.decode(msg.Data)
		ReceivedData = res
		print(Colors.green .. "You have received the data from the 0rbit process.")
	end
)

Handler that will receive the data from the 0rbit process and print it.

> Step 3: Fund your process
Transfer some $0RBT to your processID. You can check how much $0RBT you have using the following command:

Send({Target="BUhZLMwQ6yZHguLtJYA5lLUa9LQzLXMXRfaq9FVcPJc", Action="Balance"})
=
Wait a few seconds for the response and check your inbox using the below command to see your balance.

Inbox[#Inbox].Data

> Step 4: Call the Handler
Call the handler, who will create a request for the 0rbit process.

Send({ Target= ao.id, Action="First-Get-Request" })

> Step 5: Check the Data
Makes sure to wait atleast 6-9 seconds for the response to arrive.

To check the data stored in the ReceivedData variable, run the following command:

ReceivedData