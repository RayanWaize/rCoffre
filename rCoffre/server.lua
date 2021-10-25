ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('rCoffre:getStockItems', function(source, cb, society)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('rCoffre:getStockItem')
AddEventHandler('rCoffre:getStockItem', function(itemName, count, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showAdvancedNotification', _source, 'Coffre', '~o~Informations~s~', 'Vous avez retiré ~r~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)

ESX.RegisterServerCallback('rCoffre:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('rCoffre:putStockItems')
AddEventHandler('rCoffre:putStockItems', function(itemName, count, society)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez déposé ~g~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)