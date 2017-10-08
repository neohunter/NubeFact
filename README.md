# NubeFact

Ruby gem to consume NubeFact API to generate electronic tax document in PERU.

Currently only has an interface to create invoice, but can be used easily to consume other operations.

NubeFact API documentation: https://docs.google.com/document/d/1QWWSILBbjd4MDkJl7vCkL2RZvkPh0IC7Wa67BvoYIhA/edit

Se pueden hacer 4 tipos de operaciones con nuestra API:

```
OPERACIÓN 1: GENERAR FACTURAS, BOLETAS Y NOTAS
OPERACIÓN 2: CONSULTA DE FACTURAS, BOLETAS Y NOTAS
OPERACIÓN 3: GENERAR ANULACIÓN DE FACTURAS, BOLETAS Y NOTAS
OPERACIÓN 4: CONSULTA ANULACIÓN DE FACTURAS, BOLETAS Y NOTAS
```

## How to use:

```ruby

# Set your url_token and api_token.
# If you are using rails copy this 2 lines to config/initilizers/nubefact.rb
NubeFact.url_token = '93123123-ecfc-4496-ac6e-8add6940e238'
NubeFact.api_token = '29842498b15ff41f9817f036b23182e789d5a04f28ca14255822a59bfcee00e4e'
```

## Create an Electronic Invoice

```ruby
# create a new Invoice object
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

# Add items
# You don't need to add the fields that are calculated like total or igv
# those got calculated automatically.

invoice.add_item({
  unidad_de_medida: 'ZZ',
  descripcion: 'Osito de peluche de taiwan',
  cantidad: 1,
  valor_unitario: 65.00,
  tipo_de_igv: 16,
})

result = invoice.deliver

```