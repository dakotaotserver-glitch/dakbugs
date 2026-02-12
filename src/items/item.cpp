// Item Attributes reorganization

class Item {
public:
    // Existing attributes
    int attack;
    int defense;
    int magic_level; // Moved this line for display order
    int protections;
    // Other attributes...

    void DisplayAbilities() {
        // Display order: Attack, Defense, Magic Level, Protections
        std::cout << "Attack: " << attack << "\n";
        std::cout << "Defense: " << defense << "\n";
        std::cout << "Magic Level: " << magic_level << "\n";
        std::cout << "Protections: " << protections << "\n";
    }
    // Other methods...
};