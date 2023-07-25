RSG-HEADBAG Mad Respects to the original Script '[cad-headbag](https://github.com/cadburry6969/cad-headbag)' for qb-core fiveM. Fully Converted to RSG by RMS_dnb



#Info Place a bag on someones head so they cant see. Each bucket has 5 uses before it deletes from your inventory. Please add everything below so the script works properly. You can see the Durability of the bucket each time you use it, located in your inventory if you hover over the item.

# Dependencies
* qb-core

# Install Guide

> Add the below code in `qb-core/shared/items.lua`
```lua
["headbag"] = { ["name"] = "headbag", ["label"] = "Head Bag", ["weight"] = 400, ["type"] = "item", ["image"] = "headbag.png", ["unique"] = true, ["useable"] = true, ["shouldClose"] = true, ["combinable"] = nil, ["description"] = "A bag to put over someone elses head and make them blind." },
```

> Add `headbag.png` to `qb-inventory/html/images`

> Add the below code in `qb-inventory/html/js` under `FormatItemInfo` function
```lua
else if (itemData.name == "headbag") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html(
        "<p>" + Math.floor((itemData.info.uses / 5) * 100) + " Durability.</p>"
    );
} 
```

> Add the below code in `qb-inventory/server/main.lua` under `giveitem` command
```lua
elseif itemData["name"] == "headbag" then
	info.uses = 5
```

> To add headbag in shop add below code in `qb-shops/config.lua` (OPTIONAL)
```lua
[13] = { -- change this [13] according to your order
    name = "headbag",
    price = 400,
    amount = 50,
    info = {uses=5},
    type = "item",
    slot = 13, -- change this [13] according to your order
},
```

> Note: if you want to give headbag in any other resource then you have to pass the info.uses for that item
```lua
    -- Example (server): 
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("headbag", 1, false, {uses=5})
```
