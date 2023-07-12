class SalesProperty {
  final String? propety_id;
  final String? featured_property;
  final String? property_code;
  final String? listing_type;
  final String? property_type;
  final String? property_sub_type;
  final String? property_description;
  final String? property_status;
  final List<String>? images;
  SalesProperty({
    this.featured_property,
    this.images,
    this.property_code,
    this.listing_type,
    this.property_description,
    this.property_status,
    this.property_sub_type,
    this.property_type,
    this.propety_id,
  });
}
