class NubeFact::Invoice < NubeFact::Document
  TIPO_DE_COMPROBANTE = 1

  DEFAULT_DATA = {
                  operacion: 'generar_comprobante',
        tipo_de_comprobante: TIPO_DE_COMPROBANTE,
                      serie: 'F',
          sunat_transaction: 1,
           fecha_de_emision: ->(_i) { Date.today },
          porcentaje_de_igv: 18,
                     moneda: 1,
             tipo_de_cambio: ->(invoice) { invoice.set_tipo_de_cambio } 
  }
end