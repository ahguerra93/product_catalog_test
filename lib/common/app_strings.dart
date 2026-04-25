/// Central class for all app text strings (in Spanish).
/// Every user-visible string must come from here.
class AppStrings {
  const AppStrings._();

  // ─── App ────────────────────────────────────────────────────────────────────
  static const appName = 'Catálogo de productos';

  // ─── Common ─────────────────────────────────────────────────────────────────
  static const retry = 'Reintentar';
  static const goBack = 'Volver';
  static const back = 'Volver';
  static const clearAll = 'Limpiar todo';
  static const clearChip = 'Limpiar';
  static const skuPrefix = 'SKU';

  // ─── Product List ────────────────────────────────────────────────────────────
  static const productListTitle = 'Catálogo de productos';
  static const settingsTooltip = 'Ajustes';
  static const searchHint = 'Buscar por nombre o SKU…';
  static const filtersTooltip = 'Filtros';
  static const noProductsFound = 'No se encontraron productos';
  static const noProductsSubtitle = 'Intenta cambiar el modo de simulación en ajustes.';
  static const inStockChip = 'En stock';

  // ─── Filter Bottom Sheet ─────────────────────────────────────────────────────
  static const filtersTitle = 'Filtros';
  static const filtersCategory = 'Filtros';
  static const orderByCategory = 'Ordenar por';
  static const priceRangeCategory = 'Rango de precio';
  static const availabilityCategory = 'Disponibilidad';
  static const inStockOnly = 'Solo en stock';
  static const sortTypeCategory = 'Tipo de orden';
  static const orderCategory = 'Orden';
  static const applyFilters = 'Aplicar filtros';

  // ─── Product Card ────────────────────────────────────────────────────────────
  static const outOfStock = 'Sin stock';
  static String stockCount(int stock) => 'Stock: $stock';

  // ─── Product Detail ──────────────────────────────────────────────────────────
  static const backTooltip = 'Volver';
  static const shareProductTooltip = 'Compartir producto';
  static const productDetailTitle = 'Detalle del producto';
  static const productNotFound = 'Producto no encontrado.';
  static const stockLabel = 'Stock';
  static String stockUnits(int stock) => '$stock unidades';
  static const availableStatus = 'Disponible – listo para enviar';
  static const unavailableStatus = 'Actualmente no disponible';
  static const priceLabel = 'Precio';
  static const currencyFormLabel = 'Moneda';
  static const priceMustBePositive = 'El precio debe ser mayor a 0';
  static const pleaseSelectCurrency = 'Por favor selecciona una moneda';
  static const productUpdatedSuccess = 'Producto actualizado exitosamente';
  static const updateProduct = 'Actualizar producto';

  // ─── Settings Drawer ─────────────────────────────────────────────────────────
  static const settings = 'Ajustes';
  static const settingsSubtitle = 'Catálogo de productos';
  static const simulateAppState = 'Simular estado de la app';
  static const simulationSuccess = 'Éxito';
  static const simulationEmpty = 'Vacío';
  static const simulationError = 'Error';
  static const simulationSuccessDesc = 'Los productos cargan normalmente.';
  static const simulationEmptyDesc = 'Simula una lista de productos vacía.';
  static const simulationErrorDesc = 'Simula un error de red o de datos.';

  // ─── Startup ─────────────────────────────────────────────────────────────────
  static const failedToInitialize = 'Error al inicializar la app';

  // ─── Error View ──────────────────────────────────────────────────────────────
  static const somethingWentWrong = 'Algo salió mal';

  // ─── Share ───────────────────────────────────────────────────────────────────
  static String shareProductText({
    required String name,
    required String price,
    required String sku,
  }) =>
      'Nombre: $name\nPrecio: $price\nSKU: $sku';

  // ─── Sort Type Labels ────────────────────────────────────────────────────────
  static const sortByPrice = 'Precio';
  static const sortByName = 'Nombre';
  static const sortBySku = 'SKU';

  // ─── Order By Labels ─────────────────────────────────────────────────────────
  static const ascending = 'Ascendente';
  static const descending = 'Descendente';
}
