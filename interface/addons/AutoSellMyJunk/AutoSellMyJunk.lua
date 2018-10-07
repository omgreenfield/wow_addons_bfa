-- Author      : Jennifer Liford
-- Create Date : 3/29/2018 10:18:27 AM

function oncall()
	autosell:RegisterEvent("MERCHANT_SHOW");

end


	function AutoSell()
	--to sell junk items at a vendor when vendor window is opened... also lists sold items in chat
	for x = 0, 4 do for y = 1, GetContainerNumSlots(x) do local n = GetContainerItemLink(x,y)
	if n and string.find(n,"ff9d9d9d") then DEFAULT_CHAT_FRAME:AddMessage("Selling "..n) UseContainerItem(x,y) end end end

	end


