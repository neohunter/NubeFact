$: << Dir.pwd + '/lib'
require 'pry'
require 'nube_fact'

NubeFact.url_token = '8bcf167e-ecfc-4496-ac6e-8add6940e238'
NubeFact.api_token = '5046652b15ff41f9817f036b23182e789d5a04f28ca14255822a59bfcee00e4e'

invoice = NubeFact::Invoice.new({
                               serie: 'F001',
                              numero: 2,
                   sunat_transaction: 2,
           cliente_tipo_de_documento: 0,
         cliente_numero_de_documento: 'AP990427',
                cliente_denominacion: 'Bugs Bunny',
                   cliente_direccion: 'Kra 11 11 A',
                       cliente_email: 'nubefact@mailinator.com',
                              moneda: 2,
                      tipo_de_cambio: 3.25,
                   porcentaje_de_igv: 0,
                      total_inafecta: 65.00,
                               total: 65.00,
   enviar_automaticamente_a_la_sunat: false,
   enviar_automaticamente_al_cliente: true,
                        codigo_unico: 'ABC',
                      formato_de_pdf: 'A5'
})
invoice.add_item({
  unidad_de_medida: 'ZZ',
  descripcion: 'Osito de peluche de taiwan',
  cantidad: 1,
  valor_unitario: 65.00,
  tipo_de_igv: 11,
})
binding.pry

puts "DONE"