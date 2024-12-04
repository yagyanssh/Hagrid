
_0RBIT = "BaMK1dfayo75s3q1ow6AO64UDpD9SEFbeE8xYrY2fyQ"
_0RBT_TOKEN = "BUhZLMwQ6yZHguLtJYA5lLUa9LQzLXMXRfaq9FVcPJc"

BASE_URL = "https://api.weavescan.dev/api/content/items/projects"
FEE_AMOUNT = "1000000000000" -- 1 $0RBT

-- 

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

-- 

ReceivedData = ReceivedData or {}

-- 

Send({Target="BUhZLMwQ6yZHguLtJYA5lLUa9LQzLXMXRfaq9FVcPJc", Action="Balance"})

-- {
--     receive = function: 0x65dd460,
--     onReply = function: 0x65dd360,
--     output = "Message added to outbox"
--  }

-- 

Inbox[#Inbox].Data

-- 

Send({ Target= ao.id, Action="First-Get-Request" })

-- 

ReceivedData

-- 

local data = ReceivedData
-- Function to filter projects based on a query

function filterProjects(query, projects)
    local keywords = {}
    for word in string.gmatch(query, "%S+") do
        table.insert(keywords, word:lower())
    end
    
    function matches(project)
        -- Search across all fields in the original data
        for _, keyword in ipairs(keywords) do
            local found = false
            
            -- Convert project data to string for comprehensive searching
            local projectString = json.encode(project.data):lower()
            
            if projectString:find(keyword) then
                found = true
            end
            
            if found == false then return false end
        end
        return true
    end
    
    -- Filter the projects
    local result = {}
    for _, project in ipairs(projects) do
        if matches(project) then
            table.insert(result, project)
        end
    end
    
    return result
end



--

json = require('json')
	
Handlers.add("Last.Last", Handlers.utils.hasMatchingTag("Action", "Query"), function(msg)
    local filteredProjects = filterProjects(msg.Data, ReceivedData)
    
    -- Prepare response, using the stored full data
    local response = {}
    for _, project in ipairs(filteredProjects) do
        table.insert(response, project.data)
        print(project.title)
        print(project.description)
        print(project.link)
    end
    
    msg.reply({
        Data = json.encode(response),
        Action = "Last.Reply"
    })
end)

-- Indexing handler

json = require('json')

Handlers.add("Index", Handlers.utils.hasMatchingTag("Action", "Index"), function(msg)
    -- Parse the incoming project data
    local success, newProject = pcall(json.decode, msg.Data)
    
    -- Check if JSON parsing was successful
    if not success then
        msg.reply({
            Action = "Index.Error",
            Data = json.encode({
                error = "Invalid JSON format",
                status = "failed"
            })
        })
        return
    end
    
    -- Basic validation to ensure title exists
    if not newProject.title or newProject.title == "" then
        msg.reply({
            Action = "Index.Error",
            Data = json.encode({
                error = "Project title is required",
                status = "failed"
            })
        })
        return
    end
    
    -- Create a flexible project object that preserves all incoming fields
    local projectToStore = {
        title = newProject.title,
        -- Preserve all original fields
        data = newProject
    }
    
    -- Add to ReceivedData
    table.insert(ReceivedData, projectToStore)
    
    -- Respond with success
    msg.reply({
        Action = "Index.Success",
        Data = json.encode({
            message = "Project added successfully",
            project = projectToStore,
            status = "success"
        })
    })
end)

-- 

-- You can now send any JSON, and it will be stored
Send({
    Target = ao.id,
    Action = "Index",
    Data = json.encode({
        title = "test",
        description = "not realated to anything right now",
        link = "https://x.com/",
        twitter = "https://x.com/",
        github = "https://github.com/",
        tags = {"testdata", "whatnot related", "nononono"}
    })
})

this kind of data we wanna store in 

[
    {
        "title": "ArDrive",
        "slug": "ardrive",
        "description": "ArDrive offers never-ending storage of your most valuable files. Pay once and save your memories forever.",
        "link": "https://ardrive.io",
        "twitter": "ardriveapp",
        "discord": "https://discord.com/invite/ya4hf2H",
        "telegram": "ardriveapps",
        "tags": [
            "freemium",
            "web-app",
            "open-source"
        ]
    },
    {

