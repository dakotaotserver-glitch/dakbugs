#pragma once

#include "creatures/creatures_definitions.hpp"
#include "creatures/players/proficiencies/proficiencies_definitions.hpp"

class Player;
class Item;
class ItemType;

struct ProficiencyPerk {
    ProficiencyPerk(uint8_t positionSlot, WeaponProficiencyPerkType_t id, float value)
        : positionSlot(positionSlot), perkType(id), perkValue(value) { }

    uint8_t positionSlot;
    WeaponProficiencyPerkType_t perkType;
    float perkValue;

    int8_t skillId = 0;
    uint8_t augmentType = 0;
    uint16_t spellId = 0;
    uint8_t bestiaryId = 0;
    int32_t damageType = 0;
    uint8_t range = 0;
    //std::string bestiaryName = "";
};

struct ProficiencyLevelStruct {
    ProficiencyLevelStruct(uint8_t level, uint8_t maxPerks) : proficiencyLevel(level), maxProficiencyPerks(maxPerks) { }

    uint8_t proficiencyLevel;
    uint8_t maxProficiencyPerks;
    std::vector<ProficiencyPerk> proficiencyDataPerks;
};

struct WeaponProficiencyStruct {
    WeaponProficiencyStruct() : proficiencyId (0), maxProficiencyLevel(0) {}
    WeaponProficiencyStruct(uint32_t id , uint8_t maxLevel) : proficiencyId(id), maxProficiencyLevel(maxLevel) { }

    uint32_t proficiencyId;
    uint8_t maxProficiencyLevel;
    std::vector<ProficiencyLevelStruct> proficiencyDataLevel;
};

class Proficiencies {
public:
    Proficiencies() = default;

    // non-copyable
    Proficiencies(const Proficiencies &) = delete;
    Proficiencies &operator=(const Proficiencies &) = delete;

    static Proficiencies& getInstance();

    bool loadFromJson(bool reloading = false);
    bool reload();
    const WeaponProficiencyStruct* getProficiencyByItemId(uint16_t itemId) const;
    uint8_t getMaxProficiencyLevelForItem(uint16_t itemId) const;
    uint8_t getMaxPerksPerProficiencyLevelForItem(uint16_t itemId, uint8_t level) const;

protected:
    bool loaded = false;

private:
    std::unordered_map<uint32_t, WeaponProficiencyStruct> proficienciesMap; // proficiencyId - WeaponProficiencyStruct
};

constexpr auto g_proficiencies = Proficiencies::getInstance;
