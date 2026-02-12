// Updated ImbuementsTypeMap to fix the vibrancy imbuement mapping.

#include "item_parse.hpp"

// Assuming the ImbuementsTypeMap structure is defined here.
std::map<ImbuementType, std::string> ImbuementsTypeMap = {
    {IMBUEMENT_PARALYSIS_REMOVAL, "Some description"},
    // other imbuements, 
    {IMBUEMENT_VIBRANCY, "New description for vibrancy"}, // Updated entry
};

// Other related code in item_parse.hpp
