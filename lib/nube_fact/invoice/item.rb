class NubeFact::Invoice::Item
  attr_accessor "unidad_de_medida",
           "codigo",
           "descripcion",
           "cantidad",
           "valor_unitario",
           "precio_unitario",
           "descuento",
           "subtotal",
           "tipo_de_igv",
           "igv",
           "total",
           "anticipo_regularizacion",
           "anticipo_documento_serie",
           "anticipo_documento_numero"
end