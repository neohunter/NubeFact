class NubeFact::CreditNote < NubeFact::Document
  TIPO_DE_COMPROBANTE = 3

  add_required_fields *%i( documento_que_se_modifica_tipo
                           documento_que_se_modifica_serie
                           documento_que_se_modifica_numero
                           tipo_de_nota_de_credito)

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