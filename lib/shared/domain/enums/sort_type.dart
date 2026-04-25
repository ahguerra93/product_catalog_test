enum SortType {
  price('Price'),
  name('Name'),
  sku('SKU');

  final String label;

  const SortType(this.label);
}
