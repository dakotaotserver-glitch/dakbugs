// Updated parseImbuement function to handle vibrancy mapping and log key attributes

void parseImbuement(imbuementType imbuement) {
    // Handle vibrancy mapping
    if (imbuement.vibrancyMapping) {
        log("Vibrancy mapped: " + imbuement.vibrancyMapping);
    }
    
    // Log key attributes instead of value attributes
    log("Key Attribute: " + imbuement.keyAttribute);
    
    // Additional logic for parsing imbuement...
}