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

	// CORREÇÃO: Não descontar tempo ao parar o decay.
	// O checkImbuementDecay já faz a dedução corretamente a cada 60 segundos.
	// Evita a dupla dedução que causava imbuements acabando mais rápido.

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

			const auto &playerTile = player->getTile();
			const bool isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
			bool isInFightMode = player->hasCondition(CONDITION_INFIGHT);

			const auto imbuement = imbuementInfo.imbuement;
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

			const auto &parent = item->getParent();
			const bool isInBackpack = parent && parent->getContainer();

			// Item na backpack = não equipado = não decai
			if (isInBackpack) {
				continue;
			}

			// CORREÇÃO: Usar categoryImbuement->agressive (do XML) ao invés de comparar nomes
			// agressive=0 no XML: Increase Speed (cat 10), Increase Capacity (cat 17), Paralysis Deflection (cat 19)
			// Essas decaem SEMPRE que equipadas, mesmo em PZ e fora de combate.
			bool isNonAggressive = (categoryImbuement && !categoryImbuement->agressive);

			if (!isNonAggressive) {
				// Imbuements agressivos: só decaem em combate PVP/PVE e FORA de PZ
				if (isInProtectionZone || !isInFightMode) {
					continue;
				}
			}
			// Se isNonAggressive, cai direto aqui (decai sempre que equipado)

			if (imbuementInfo.duration == 0) {
				player->removeItemImbuementStats(imbuement);
				player->updateImbuementTrackerStats();
				continue;
			}

			g_logger().debug("Decaying imbuement {} from item {} of player {}", imbuement->getName(), item->getName(), player->getName());
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

	for (const auto &item : itemsToRemove) {
		m_itemsToDecay.erase(item);
	}

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
