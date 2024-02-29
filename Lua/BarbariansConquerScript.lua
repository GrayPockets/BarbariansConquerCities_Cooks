
--include( "PopupDialog" );

local checkRF = false;

function OnDistrictDamageChanged( playerID:number, districtID:number, damageType:number, newDamage:number, oldDamage:number)

	--if (Players[playerID]:IsHuman() or playerID == Game.GetLocalObserver()) then -- Allow for City States/AI to get murdered also
	print("OnDistrictDamageChanged: "..playerID.." "..districtID.." "..damageType.." newDamage:"..newDamage.." oldDamage:"..oldDamage);
	if (playerID ~= 62) then -- Don't send a Free City to the Free Cities
		if (damageType == DefenseTypes.DISTRICT_GARRISON) then
			--print("OK damageType");
			local cityDistrict = CityManager.GetDistrict(playerID, districtID);
			if (cityDistrict ~= nil) then
				local cityDistrictType = cityDistrict:GetType();
				--print("OK cityDistrict cityDistrictType: "..tostring(cityDistrictType));
				if cityDistrictType == 0 then
					local maxHitpoints = cityDistrict:GetMaxDamage(damageType);
					--print("maxHitpoints: "..tostring(maxHitpoints));
					if newDamage == maxHitpoints-1 then
						local city = CityManager.GetCity(playerID, districtID);
						local cityName:string = city:GetName();
						local cityName = Locale.Lookup(cityName);
						if checkRF then
							print("OnDistrictDamageChanged: CONQUERED "..tostring(checkRF));
							local gossipText = "Barbarians conquered "..cityName.."!";
							LuaEvents.Custom_GossipMessage(gossipText, gTime, ReportingStatusTypes.GOSSIP);
							--city:ChangeLoyalty(-111); -- Loyalty only flips city if it's losing Loyalty every turn
							CityManager.TransferCityToFreeCities(city); -- Guaranteed to flip
						else
							print("OnDistrictDamageChanged: DESTROYED "..tostring(checkRF));
							CityManager.DestroyCity( playerID, districtID );
							local gossipText = "Barbarians destroyed "..cityName.."!";
							LuaEvents.Custom_GossipMessage(gossipText, gTime, ReportingStatusTypes.GOSSIP);
						end --checkRF
					end --newDamage
				end --cityDistrictType
			end --cityDistrict not nil
		end --damageType
	end -- playerID ~= 62
	--end --playerID == humanID
end

function Initialize()
	
	Events.DistrictDamageChanged.Add(			OnDistrictDamageChanged );
	checkRF = Players[62]:IsInitialized();
	print("BARBARIANS CONQUER SCRIPT STARTED v.Cooks:"..tostring(checkRF));
	
end

Initialize();
