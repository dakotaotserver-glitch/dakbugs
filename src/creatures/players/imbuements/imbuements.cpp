// Full C++ code extracted from imbuements.cpp with modifications applied

#include "creatures/players/imbuements/imbuements.hpp"
#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/di/container.hpp"
#include "utils/pugicast.hpp"
#include "utils/const.hpp"
#include "utils/tools.hpp"

// ... (other code omitted for brevity)

// ImbuementDecay class implementation

ImbuementDecay &ImbuementDecay::getInstance() {
	return inject<ImbuementDecay>();
}

void ImbuementDecay::startImbuementDecay(const std::shared_ptr<Item> &item) {
	if (!item) {
		g_logger().error("[{}] item is nullptr", __FUNCTION__);
		return;
	}

	if (m_itemsToDecay.find(item) != m_itemsToDecay.end()) {
		return;
	}

	g_logger().debug("Starting imbuement decay for item {}", item->getName());

	m_itemsToDecay.insert(item);

	if (m_eventId == 0) {
		m_lastUpdateTime = OTSYS_TIME();
		m_eventId = g_dispatcher().scheduleEvent(
			60000, [this] { checkImbuementDecay(); }, "ImbuementDecay::checkImbuementDecay"
		);
		g_logger().trace("Scheduled imbuement decay check every 60 seconds.");
	}
}

void ImbuementDecay::stopImbuementDecay(const std::shared_ptr<Item> &item) {
	if (!item) {
		g_logger().error("[{}] item is nullptr", __FUNCTION__);
		return;
	}

	g_logger().debug("Stopping imbuement decay for item {}", item->getName());

	int64_t currentTime = OTSYS_TIME();
	int64_t elapsedTime = currentTime - m_lastUpdateTime;

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); ++slotid) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		uint32_t duration = imbuementInfo.duration > elapsedTime / 1000 ? imbuementInfo.duration - static_cast<uint32_t>(elapsedTime / 1000) : 0;
		item->decayImbuementTime(slotid, imbuementInfo.imbuement->getID(), duration);

		if (duration == 0) {
			if (auto player = item->getHoldingPlayer()) {
				player->removeItemImbuementStats(imbuementInfo.imbuement);
				player->updateImbuementTrackerStats();
			}
		}
	}

	m_itemsToDecay.erase(item);

	if (m_itemsToDecay.empty() && m_eventId != 0) {
		g_dispatcher().stopEvent(m_eventId);
		m_eventId = 0;
		g_logger().trace("No more items to decay. Stopped imbuement decay scheduler.");
	}
}

void ImbuementDecay::checkImbuementDecay() {
	int64_t currentTime = OTSYS_TIME();
	int64_t elapsedTime = currentTime - m_lastUpdateTime;
	m_lastUpdateTime = currentTime;

	g_logger().trace("Checking imbuement decay for {} items.", m_itemsToDecay.size());

	std::vector<std::shared_ptr<Item>> itemsToRemove;

	for (const auto &item : m_itemsToDecay) {
		if (!item) {
			g_logger().error("[{}] item is nullptr", __FUNCTION__);
			itemsToRemove.push_back(item);
			continue;
		}

		// Get the player holding the item (if any)
		auto player = item->getHoldingPlayer();
		if (!player) {
			g_logger().debug("Item {} is not held by any player. Skipping decay.", item->getName());
			continue;
		}

		bool removeItem = true;

		for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); ++slotid) {
			ImbuementInfo imbuementInfo;
			if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
				g_logger().debug("No imbuement info found for slot {} in item {}", slotid, item->getName());
				continue;
			}

			// Get the tile the player is currently on
			const auto &playerTile = player->getTile();
			// Check if the player is in a protection zone
			const bool &isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
			// Check if the player is in fight mode
			bool isInFightMode = player->hasCondition(CONDITION_INFIGHT);

			// Imbuement from imbuementInfo, this variable reduces code complexity
			const auto imbuement = imbuementInfo.imbuement;
			// Get the category of the imbuement
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
			// Parent of the imbued item
			const auto &parent = item->getParent();
			const bool &isInBackpack = parent && parent->getContainer();

			// Modified logic: Define exceptions and apply custom skip rules
			bool isPassiveException = (imbuement->getName() == "Increase Capacity" || imbuement->getName() == "Paralysis Deflection" || imbuement->getName() == "Increase Speed");

			// For exceptions: decay always if equipped (not in backpack)
			if (isPassiveException) {
				if (isInBackpack) {
					continue;
				}
			} else {
				// For normal imbuements: decay only in PVP/PVE combat (not in PZ, in fight mode, not in backpack)
				if (isInProtectionZone || !isInFightMode || isInBackpack) {
					continue;
				}
			}

			// Removed the original second if for !agressive, as it's redundant with new logic

			// If the imbuement's duration is 0, remove its stats and continue to the next slot
			if (imbuementInfo.duration == 0) {
				player->removeItemImbuementStats(imbuement);
				player->updateImbuementTrackerStats();
				continue;
			}

			g_logger().debug("Decaying imbuement {} from item {} of player {}", imbuement->getName(), item->getName(), player->getName());
			// Calculate the new duration of the imbuement, making sure it doesn't go below 0
			uint32_t duration = imbuementInfo.duration > elapsedTime / 1000 ? imbuementInfo.duration - static_cast<uint32_t>(elapsedTime / 1000) : 0;
			item->decayImbuementTime(slotid, imbuement->getID(), duration);

			if (duration == 0) {
				player->removeItemImbuementStats(imbuement);
				player->updateImbuementTrackerStats();
			}

			removeItem = false;
		}

		if (removeItem) {
			itemsToRemove.push_back(item);
		}
	}

	// Remove items whose imbuements have expired
	for (const auto &item : itemsToRemove) {
		m_itemsToDecay.erase(item);
	}

	// Reschedule the event if there are still items
	if (!m_itemsToDecay.empty()) {
		m_eventId = g_dispatcher().scheduleEvent(
			60000, [this] { checkImbuementDecay(); }, "ImbuementDecay::checkImbuementDecay"
		);
		g_logger().trace("Re-scheduled imbuement decay check.");
	} else {
		m_eventId = 0;
		g_logger().trace("No more items to decay. Stopped imbuement decay scheduler.");
	}
}
